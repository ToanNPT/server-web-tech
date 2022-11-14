package com.hcmute.backendtechnologicalapplianceswebsite.repository.dashboard;

import com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad.Chart;
import com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad.TotalSales;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TotalSalesRepository extends JpaRepository<TotalSales, String> {
    @Query(value = "select 1 as id,sum(TotalPrice)as total from Products,Categories,OrderDetails where Categories.CategoryId=Products.CategoryId and OrderDetails.ProductId=Products.ProductId and Products.CategoryId='C01'", nativeQuery = true)
    Iterable<TotalSales> totalLaptop();
    @Query(value = "select 2 as id,sum(TotalPrice)as total from Products,Categories,OrderDetails where Categories.CategoryId=Products.CategoryId and OrderDetails.ProductId=Products.ProductId and Products.CategoryId='C02'", nativeQuery = true)
    Iterable<TotalSales> totalMobile();
    @Query(value = "select 3 as id, sum(TotalPrices)as total from orders", nativeQuery = true)
    Iterable<TotalSales> totalAll();
}
