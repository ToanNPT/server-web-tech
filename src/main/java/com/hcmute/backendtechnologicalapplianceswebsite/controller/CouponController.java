package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Coupon;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.CouponRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class CouponController {
    private final CouponRepository couponRepository;

    public CouponController(CouponRepository couponRepository) {
        this.couponRepository = couponRepository;
    }

    @GetMapping("/coupons")
    public Iterable<Coupon> getAllCoupons() {
        log.info("Get all coupons");
        return couponRepository.findAll();
    }

    @PostMapping("/coupons")
    public Coupon createBrand(@RequestBody Coupon coupon) {
        log.info("Create coupon: {}", coupon);
        return couponRepository.save(coupon);
    }

    @GetMapping("/coupons/{id}")
    public ResponseEntity<Coupon> getCouponById(@PathVariable String id) {
        Coupon coupon = couponRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Coupon not found with id " + id));

        log.info("Get coupon by id: " + id);
        return ResponseEntity.ok(coupon);
    }

    //    Update brand
    @PutMapping("/coupons/{id}")
    public ResponseEntity<Coupon> updateCoupon(@PathVariable String id, @RequestBody Coupon coupon) {
        Coupon _coupon = couponRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Coupon not found with id " + id));
        coupon.setCouponId(_coupon.getCouponId());

        log.info("Update coupon: " + coupon);
        return ResponseEntity.ok(couponRepository.save(coupon));
    }


    @DeleteMapping("/coupons/{id}")
    public ResponseEntity<Coupon> deleteCoupon(@PathVariable String id) {
        Coupon coupon = couponRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Coupon not found with id " + id));
        couponRepository.delete(coupon);

        log.info("Delete coupon: " + coupon);
        return ResponseEntity.ok(coupon);
    }
}
