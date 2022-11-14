package com.hcmute.backendtechnologicalapplianceswebsite.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;

@Entity
@Table(name = "Account")
public class Account implements Serializable {
    @JsonIgnore
    public static final int ROLE_USER = 0;
    @JsonIgnore
    public static final int ROLE_ADMIN = 1;

    public Account() {

    }

    public Account(String username, String password, Integer role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    @JsonIgnore
    public static String getRoleName(int role) {
        if (role == ROLE_USER) {
            return "ROLE_USER";
        } else if (role == ROLE_ADMIN) {
            return "ROLE_ADMIN";
        }
        return "";
    }

    @Id
    @Column(name = "Username", nullable = false, length = 40)
    private String username;

    @MapsId
    @OneToOne(fetch = FetchType.EAGER, optional = false, cascade = CascadeType.ALL)
    @JoinColumn(name = "Username", nullable = false)
    private User user;

    @JsonIgnore
    @Column(name = "Password", nullable = false, length = 40)
    private String password;

    @Column(name = "Role")
    private Integer role;

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User users) {
        this.user = users;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String id) {
        this.username = id;
    }

    @Override
    public String toString() {
        return "Account: username=" + username + ", password=" + password;
    }

    @JsonIgnore
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Collection<SimpleGrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(getRoleName(role)));
        return authorities;
    }
}