package com.hcmute.backendtechnologicalapplianceswebsite.model;

import javax.persistence.*;
import java.util.Date;

@Entity
public class PasswordResetToken {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false, length = 40)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Username")
    private User user;

    @Column(name = "Token", nullable = false, length = 60)
    private String token;

    @Column(name = "Expiry", nullable = false)
    private Date expiry;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User username) {
        this.user = username;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiry() {
        return expiry;
    }

    public void setExpiry(Date expiry) {
        this.expiry = expiry;
    }

}