package com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "TopCustomer")
public class TopCustomer {
    @Id
    @Column(name = "id")
    String Id;
    @Column(name = "name")
    String Name;
    @Column(name = "total")
    double Total;

    public TopCustomer() {
    }

    public TopCustomer(String Id, String Name, double Total) {
        this.Id = Id;
        this.Name = Name;
        this.Total = Total;
    }

    public String getId() {
        return Id;
    }

    public void setId(String id) {
        Id = id;
    }

    public double getTotal() {
        return Total;
    }

    public void setTotal(double total) {
        Total = total;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }
}
