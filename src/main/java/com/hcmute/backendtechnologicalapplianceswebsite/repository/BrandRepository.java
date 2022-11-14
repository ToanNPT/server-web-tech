package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Brand;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BrandRepository extends JpaRepository<Brand, String> {
    Brand findByBrandId(String id);

    default String generateBrandId() {
        String PREFIX = "B";
        int index = PREFIX.length();
        int length = 2;

        List<Brand> brands = findAll();

        if (brands.size() == 0) {
            return PREFIX + "01"; // first brand
        }

        brands.sort((c1, c2) -> {
            Long id1 = Long.parseLong(c1.getBrandId().substring(index));
            Long id2 = Long.parseLong(c2.getBrandId().substring(index));
            return id2.compareTo(id1);
        });

        String lastBrandId = brands.get(0).getBrandId();

        return MyUtils.generateID(PREFIX, length, lastBrandId);
    }
}