package com.hcmute.backendtechnologicalapplianceswebsite.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.time.Instant;
import java.util.Date;

@Entity
@Table(name = "Coupons")
public class Coupon implements Serializable {
    @Id
    @Column(name = "CouponId", nullable = false, length = 40)
    private String couponId;

    @Column(name = "Discount", nullable = false)
    private Double discount;

    @Column(name = "ExpiredTime")
    private Date expiredTime;

    @Column(name = "EffectiveTime")
    private Date effectiveTime;

    @Column(name = "Description", length = 300)
    private String description;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getEffectiveTime() {
        return effectiveTime;
    }

    public void setEffectiveTime(Date effectiveTime) {
        this.effectiveTime = effectiveTime;
    }

    public Date getExpiredTime() {
        return expiredTime;
    }

    public void setExpiredTime(Date expiredTime) {
        this.expiredTime = expiredTime;
    }

    public Double getDiscount() {
        return discount;
    }

    public void setDiscount(Double discount) {
        this.discount = discount;
    }

    public String getCouponId() {
        return couponId;
    }

    public void setCouponId(String id) {
        this.couponId = id;
    }
}