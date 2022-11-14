package com.hcmute.backendtechnologicalapplianceswebsite.repository.dashboard;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Product;
import com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad.Chart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ChartRepository extends JpaRepository<Chart, String> {
    @Query(value = "select DAY(PurchaseDate) as name,sum(TotalPrices) as total from Orders where MONTH(GetDate())=MONTH(PurchaseDate) group by DAY(PurchaseDate)", nativeQuery = true)
    Iterable<Chart> getTotalByMonth();
}
