package com.hcmute.backendtechnologicalapplianceswebsite.repository.dashboard;

import com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad.TopProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TopProductRepository extends JpaRepository<TopProduct, String>
{
    @Query(value = "select top(6) id,Name as name,sold,total,Quantity as quantity from (select ProductId as id,sum(TotalPrice) as total,sum(Quantity) as sold  from orderdetails group by ProductId) D,Products where D.id=ProductId order by total DESC", nativeQuery = true)
    Iterable<TopProduct> getTopProduct();
}
