package com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "TotalSales")
public class TotalSales {
    @Id
    @Column(name = "id")
    int Id;
    @Column(name = "total")
    double Total;

    public TotalSales() {
    }

    public TotalSales(int Name, double Total) {
        this.Id = Name;
        this.Total = Total;
    }

    public int getId() {
        return Id;
    }

    public void setId(int name) {
        this.Id = name;
    }

    public double getTotal() {
        return Total;
    }

    public void setTotal(double total) {
        Total = total;
    }
}
