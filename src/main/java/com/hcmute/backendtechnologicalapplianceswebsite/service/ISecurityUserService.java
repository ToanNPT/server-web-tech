package com.hcmute.backendtechnologicalapplianceswebsite.service;

import com.hcmute.backendtechnologicalapplianceswebsite.model.User;

public interface ISecurityUserService {
    String validatePasswordResetToken(String token);

    void createPasswordResetTokenForUser(User user, String token);

}