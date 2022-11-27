package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AccountRepository extends JpaRepository<Account, String> {
    @Query("select (count(a) > 0) from Account a")
    boolean existsByEmail();

    @Query("select a " +
            "from Account as a " +
            "where a.role = 2")
    List<Account> getShipperAccount();


}