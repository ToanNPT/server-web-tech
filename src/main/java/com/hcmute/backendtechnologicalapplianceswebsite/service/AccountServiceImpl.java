package com.hcmute.backendtechnologicalapplianceswebsite.service;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.userdetails.User;

import java.util.List;

@Service @RequiredArgsConstructor @Transactional @Slf4j
public class AccountServiceImpl implements AccountService, UserDetailsService {
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Account account = accountRepository.findById(username)
                .orElseThrow(() -> {
                    log.error("Account not found with username: " + username);
                    return new UsernameNotFoundException("Account not found with username: " + username);
                });
        log.info("Account found with username: " + username);
        return new User(account.getUsername(),
                account.getPassword(),
                account.getAuthorities());
    }

    @Override
    public Account saveAccount(Account account) {
        log.info("Save account: {}", account);
        account.setPassword(passwordEncoder.encode(account.getPassword()));
        return accountRepository.save(account);
    }

    @Override
    public void changeAccountRole(String username, int role) {
        log.info("Change account role: {} to {}", username, Account.getRoleName(role));
        Account account = accountRepository.findById(username)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        account.setRole(role);
        accountRepository.save(account);
    }

    @Override
    public Account getAccountByUsername(String username) {
        log.info("Get account by username: {}", username);
        return accountRepository.findById(username)
                .orElseThrow(() -> new RuntimeException("Account not found"));
    }

    @Override
    public List<Account> getAllAccount() {
        log.info("Get all account");
        return accountRepository.findAll();
    }
}
