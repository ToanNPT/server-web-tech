package com.hcmute.backendtechnologicalapplianceswebsite.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.io.Serializable;
import java.time.Instant;
import java.util.Date;

@Entity
@Table(name = "Reviews")
public class Review  implements Serializable {
    @Id
    @Column(name = "ReviewId", nullable = false, length = 20)
    private String reviewId;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Username")
    private User user;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ProductId")
    private Product product;

    @Lob
    @Column(name = "Content")
    private String content;

    @Column(name = "Rate")
    private Integer rate;

    @Column(name = "Time")
    private Date time;

    public Review() {

    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Integer getRate() {
        return rate;
    }

    public void setRate(Integer rate) {
        this.rate = rate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public User getUser() {
        return user;
    }

    public String getUsername() {
        return user.getUsername();
    }

    public void setUser(User username) {
        this.user = username;
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String id) {
        this.reviewId = id;
    }

    public String getProductId() {
        return product.getProductId();
    }
}