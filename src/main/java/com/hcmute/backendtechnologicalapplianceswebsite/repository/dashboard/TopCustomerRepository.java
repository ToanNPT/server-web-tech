package com.hcmute.backendtechnologicalapplianceswebsite.repository.dashboard;

import com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad.TopCustomer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TopCustomerRepository extends JpaRepository<TopCustomer, String> {
    @Query(value = "select top(5) D.Username as id,Name as name,total from (select Username, Sum(TotalPrices)as total from orders group by Username) D, Users where D.Username=Users.Username order by total DESC", nativeQuery = true)
    Iterable<TopCustomer> getTopCustomer();

}
