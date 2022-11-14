package com.hcmute.backendtechnologicalapplianceswebsite.service;

import com.hcmute.backendtechnologicalapplianceswebsite.model.PasswordResetToken;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.PasswordResetTokenRepository;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class ISecurityUserServiceImpl implements ISecurityUserService {
    private final PasswordResetTokenRepository passwordTokenRepository;

    public ISecurityUserServiceImpl(PasswordResetTokenRepository passwordTokenRepository) {
        this.passwordTokenRepository = passwordTokenRepository;
    }

    @Override
    public String validatePasswordResetToken(String token) {
        PasswordResetToken passToken = passwordTokenRepository.findByToken(token);
        if (passToken == null) {
            return "invalidToken";
        }

        final Date today = new Date();
        if (passToken.getExpiry().before(today)) {
            return "expired";
        }

        return null;
    }

    @Override
    public void createPasswordResetTokenForUser(User user, String token) {
        final Date today = new Date();
        // The 30min token expiry time
        final Date expiryDate = new Date(today.getTime() + 1000 * 60 * 30);
        PasswordResetToken passToken = new PasswordResetToken();
        passToken.setToken(token);
        passToken.setUser(user);
        passToken.setExpiry(expiryDate);

        passwordTokenRepository.save(passToken);
    }
}
