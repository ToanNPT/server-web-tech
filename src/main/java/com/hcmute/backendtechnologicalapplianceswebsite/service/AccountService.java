package com.hcmute.backendtechnologicalapplianceswebsite.service;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;

import java.util.List;

public interface AccountService {
    Account saveAccount(Account account);
    void changeAccountRole(String username, int role);
    Account getAccountByUsername(String username);
    List<Account> getAllAccount();
}
