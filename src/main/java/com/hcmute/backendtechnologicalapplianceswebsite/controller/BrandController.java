package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Brand;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.BrandRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class BrandController {
    private final BrandRepository brandRepository;

    public BrandController(BrandRepository brandRepository) {
        this.brandRepository = brandRepository;
    }

    // Get All Brands
    @GetMapping("/brands")
    public Iterable<Brand> getAllBrands() {
        log.info("Get all brands");
        return brandRepository.findAll();
    }

    //    Create brand
    @PostMapping("/brands")
    public Brand createBrand(@RequestBody Brand brand) {
        //  Default value for brandId
        brand.setBrandId(brandRepository.generateBrandId());

        log.info("Create brand: " + brand);
        return brandRepository.save(brand);
    }

    //    Get brand by id
    @GetMapping("/brands/{id}")
    public ResponseEntity<Brand> getBrandById(@PathVariable String id) {
        Brand brand = brandRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Brand not found with id: " + id));

        log.info("Get brand by id: " + id);
        return ResponseEntity.ok(brand);
    }

    //    Update brand
    @PutMapping("/brands/{id}")
    public ResponseEntity<Brand> updateBrand(@PathVariable String id, @RequestBody Brand brand) {
        Brand _brand = brandRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Brand not found with id: " + id));
        _brand.setName(brand.getName());
        _brand.setEmail(brand.getEmail());
        _brand.setLocation(brand.getLocation());
        _brand.setLogo(brand.getLogo());
        brandRepository.save(_brand);

        log.info("Update brand: " + brand);
        return ResponseEntity.ok(_brand);
    }

    //    Delete brand
    @DeleteMapping("/brands/{id}")
    public ResponseEntity<Brand> deleteBrand(@PathVariable String id) {
        Brand brand = brandRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Brand not found with id: " + id));
        brandRepository.delete(brand);

        log.info("Delete brand: " + brand);
        return ResponseEntity.ok(brand);
    }
}
