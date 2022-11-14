package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Category;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, String> {
    Category findByCategoryId(String id);

    default String generateCategoryId() {
        String PREFIX = "C";
        int length = 2;

        List<Category> categories = findAll();

        if (categories.size() == 0) {
            return PREFIX + "01"; // first category
        }

        categories.sort((c1, c2) -> {
            Long id1 = Long.parseLong(c1.getCategoryId().substring(PREFIX.length()));
            Long id2 = Long.parseLong(c2.getCategoryId().substring(PREFIX.length()));
            return id2.compareTo(id1);
        });

        String lastCategoryId = categories.get(0).getCategoryId();

        return MyUtils.generateID(PREFIX, length, lastCategoryId);
    }
}