package com.hcmute.backendtechnologicalapplianceswebsite.model.account;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;

public class UserFactory extends AccountAbstractFactory {
    @Override
    public Account createAccount(String username, String password) {
        return new Account(username, password, Account.ROLE_USER);
    }
}
