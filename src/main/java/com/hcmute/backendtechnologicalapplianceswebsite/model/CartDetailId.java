package com.hcmute.backendtechnologicalapplianceswebsite.model;

import org.hibernate.Hibernate;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class CartDetailId implements Serializable {
    @Serial
    private static final long serialVersionUID = -4155608218831706701L;
    @Column(name = "Username", nullable = false, length = 40)
    private String username;
    @Column(name = "ProductId", nullable = false, length = 20)
    private String productId;

    public CartDetailId() {

    }

    public CartDetailId(String username, String productId) {
        this.username = username;
        this.productId = productId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, username);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        CartDetailId entity = (CartDetailId) o;
        return Objects.equals(this.productId, entity.productId) &&
                Objects.equals(this.username, entity.username);
    }

    @Override
    public String toString() {
        return "CartDetailId{" +
                "productId='" + productId + '\'' +
                ", username='" + username + '\'' +
                '}';
    }
}