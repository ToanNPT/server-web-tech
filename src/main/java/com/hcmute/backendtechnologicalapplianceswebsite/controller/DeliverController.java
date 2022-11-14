package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Delivery;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.DeliveryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class DeliverController {
    private final DeliveryRepository deliveryRepository;

    public DeliverController(DeliveryRepository deliveryRepository) {
        this.deliveryRepository = deliveryRepository;
    }
    // Get All Categories
    @GetMapping("/deliveries")
    public Iterable<Delivery> getAllDeliveries() {
        log.info("Get all deliveries");
        return deliveryRepository.findAll();
    }

    @GetMapping("/deliveries/{id}")
    public ResponseEntity<Delivery> getProductById(@PathVariable String id) {
        Delivery delivery = deliveryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery not found with id: " + id));

        log.info("Get delivery with id: " + id);
        return ResponseEntity.ok(delivery);
    }
    @PostMapping("/deliveries")
    public Delivery createDelivery(@RequestBody Delivery delivery) {
        //  Default value for productId
        delivery.setDeliveryId(deliveryRepository.generateDeliveryId());

        log.info("Create delivery: {}", delivery);
        return deliveryRepository.save(delivery);
    }
    @PutMapping("/deliveries/{id}")
    public ResponseEntity<Delivery> updateBrand(@PathVariable String id, @RequestBody Delivery delivery) {
        Delivery _delivery = deliveryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery not found with id: " + id));
        delivery.setDeliveryId(_delivery.getDeliveryId());

        log.info("Update delivery: {}", delivery);
        return ResponseEntity.ok(deliveryRepository.save(delivery));
    }

    @DeleteMapping("/deliveries/{id}")
    public ResponseEntity<Delivery> deleteDelevery(@PathVariable String id) {
        Delivery delivery = deliveryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery not found with id: " + id));
        deliveryRepository.delete(delivery);

        log.info("Delete delivery: {}", delivery);
        return ResponseEntity.ok(delivery);
    }
}
