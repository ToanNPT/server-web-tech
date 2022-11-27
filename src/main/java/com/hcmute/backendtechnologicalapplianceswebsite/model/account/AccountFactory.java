package com.hcmute.backendtechnologicalapplianceswebsite.model.account;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;

public class AccountFactory {
    private AccountFactory() {
    }

    public static AccountAbstractFactory getFactory(int role) {
        if (role == Account.ROLE_USER) {
            return new UserFactory();
        } else if (role == Account.ROLE_ADMIN) {
            return new AdminFactory();
        }
        else if(role == Account.ROLE_SHIPPER){
            return new ShipperFactory();
        }
        return null;
    }
}
