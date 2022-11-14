package com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "Chart")
public class Chart {
    @Id
    @Column(name = "name")
    String name;
    @Column(name = "total")
    double total;

    public Chart() {
    }

    public Chart(String name, double Total) {
        this.name = name;
        this.total = Total;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}
