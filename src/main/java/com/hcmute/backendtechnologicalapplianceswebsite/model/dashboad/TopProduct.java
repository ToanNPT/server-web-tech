package com.hcmute.backendtechnologicalapplianceswebsite.model.dashboad;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "TopProduct")
public class TopProduct {
    @Id
    @Column(name = "id")
    String Id;
    @Column(name = "name")
    String Name;
    @Column(name = "sold")
    int Sold;
    @Column(name = "total")
    double Total;
    @Column(name = "quantity")
    int Quantity;//QuantityInStock

    public TopProduct() {
    }

    public TopProduct(String Id, String Name, int Sold, double Total, int Quantity) {
        this.Id = Id;
        this.Name = Name;
        this.Sold = Sold;
        this.Total = Total;
        this.Quantity = Quantity;
    }

    public String getName() {
        return Name;
    }

    public void setTotal(double total) {
        Total = total;
    }

    public double getTotal() {
        return Total;
    }

    public void setName(String name) {
        Name = name;
    }

    public int getQuantityInStock() {
        return Quantity;
    }

    public void setId(String id) {
        Id = id;
    }

    public int getSold() {
        return Sold;
    }

    public void setQuantityInStock(int quantityInStock) {
        Quantity = quantityInStock;
    }

    public String getId() {
        return Id;
    }

    public void setSold(int sold) {
        Sold = sold;
    }

}
