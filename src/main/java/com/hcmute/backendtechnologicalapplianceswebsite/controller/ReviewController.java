package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Product;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Review;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.ProductRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.ReviewRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Date;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class ReviewController {

    private final ReviewRepository reviewRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    public ReviewController(ReviewRepository reviewRepository, ProductRepository productRepository, UserRepository userRepository) {
        this.reviewRepository = reviewRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
    }

    // Get All Reviews
    @GetMapping("/reviews")
    public Iterable<Review> getAllReviews() {
        log.info("Get all reviews");
        return reviewRepository.findAll();
    }

    // Get all reviews by product id
    @GetMapping("/reviews/product/{productId}")
    public Iterable<Review> getAllReviewsByProductId(@PathVariable(value = "productId") String productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found with id: " + productId));

        log.info("Get all reviews by product id: " + productId);
        return reviewRepository.findAllByProduct(product);
    }

    //    Create review
    @PostMapping("/reviews/{username}/{productId}")
    public Review createReview(@RequestBody Review review, @PathVariable(value = "productId") String productId, @PathVariable(value = "username") String username) {
        //  Default value for reviewId
        review.setReviewId(reviewRepository.generateReviewId());

        // Product
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found with id: " + productId));
        review.setProduct(product);

        // User
        User user = userRepository.findById(username)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username));
        review.setUser(user);

        // Time
        if (review.getTime() == null) {
            review.setTime(new Date());
        }

        log.info("Create review: " + review);
        return reviewRepository.save(review);
    }

    //    Get review by id
    @GetMapping("/reviews/{id}")
    public ResponseEntity<Review> getReviewById(@PathVariable String id) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + id));

        log.info("Get review by id: " + id);
        return ResponseEntity.ok(review);
    }

    //    Update review
    @PutMapping("/reviews/{username}/{id}")
    public ResponseEntity<Review> updateReview(@PathVariable String username, @PathVariable String id, @RequestBody Review review) {
        Review _review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + id));
        if (_review.getUsername().equals(username)) {
            _review.setContent(review.getContent());
            _review.setRate(review.getRate());

            // Time
            if (review.getTime() == null)
                _review.setTime(new Date());
            else
                _review.setTime(review.getTime());

            reviewRepository.save(_review);

            log.info("Update review: " + _review);
            return ResponseEntity.ok(_review);
        } else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You can not update review of other user");
        }
    }

    //    Delete review
    @DeleteMapping("/reviews/{username}/{id}")
    public ResponseEntity<Review> deleteReview(@PathVariable String id, @PathVariable String username) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + id));
        if (review.getUsername().equals(username)) {
            log.info("Delete review: " + review);
            reviewRepository.delete(review);
            return ResponseEntity.ok().build();
        } else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You can not delete review of other user");
        }
    }
}
