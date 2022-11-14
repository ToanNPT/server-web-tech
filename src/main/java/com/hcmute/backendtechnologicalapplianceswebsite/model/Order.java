package com.hcmute.backendtechnologicalapplianceswebsite.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Orders")
public class Order implements Serializable {
    @Id
    @Column(name = "OrderId", nullable = false, length = 20)
    private String orderId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "Username")
    private User user;

    @Column(name = "Name", nullable = false, length = 100)
    private String name;

    @Column(name = "Address", nullable = false, length = 200)
    private String address;

    @Column(name = "PhoneNumber", nullable = false, length = 20)
    private String phoneNumber;

    @Column(name = "PurchaseDate")
    private Date purchaseDate;

    @Column(name = "TotalPrices")
    private Double totalPrices;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "DeliveryId")
    private Delivery delivery;

    @Column(name = "Status", length = 200)
    private String status;

    @Column(name = "CouponId")
    private String couponId;

    @Column(name = "DiscountPrice")
    private Double discountPrice;

    public Double getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(Double discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String couponId) {
        this.couponId = couponId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Delivery getDelivery() {
        return delivery;
    }

    public void setDelivery(Delivery delivery) {
        this.delivery = delivery;
    }

    public Double getTotalPrices() {
        return totalPrices;
    }

    public void setTotalPrices(Double totalPrices) {
        this.totalPrices = totalPrices;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumer) {
        this.phoneNumber = phoneNumer;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User username) {
        this.user = username;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String id) {
        this.orderId = id;
    }
}