package com.hcmute.backendtechnologicalapplianceswebsite.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Categories")
public class Category implements Serializable {
    @Id
    @Column(name = "CategoryId", length = 20)
    private String categoryId;

    @Column(name = "Name", nullable = false, length = 100)
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String id) {
        this.categoryId = id;
    }
}