package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Product;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Review;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, String> {
    default String generateReviewId() {
        String PREFIX = "R";
        int index = PREFIX.length();
        int length = 2;

        List<Review> reviews = findAll();

        if (reviews.size() == 0) {
            return PREFIX + "01"; // first review
        }

        reviews.sort((c1, c2) -> {
            Long id1 = Long.parseLong(c1.getReviewId().substring(index));
            Long id2 = Long.parseLong(c2.getReviewId().substring(index));
            return id2.compareTo(id1);
        });

        String lastReviewId = reviews.get(0).getReviewId();

        return MyUtils.generateID(PREFIX, length, lastReviewId);
    }

    Iterable<Review> findAllByProduct(Product product);
}