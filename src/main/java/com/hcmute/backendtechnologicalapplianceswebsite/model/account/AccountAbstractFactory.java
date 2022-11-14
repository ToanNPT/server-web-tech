package com.hcmute.backendtechnologicalapplianceswebsite.model.account;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;

public abstract class AccountAbstractFactory {
    public abstract Account createAccount(String username, String password);
}
