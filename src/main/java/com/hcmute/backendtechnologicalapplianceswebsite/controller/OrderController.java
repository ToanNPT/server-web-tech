package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Delivery;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Order;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.DeliveryRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.OrderRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class OrderController {
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final DeliveryRepository deliveryRepository;

    public OrderController(OrderRepository orderRepository, UserRepository userRepository, DeliveryRepository deliveryRepository) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
        this.deliveryRepository = deliveryRepository;
    }


    @GetMapping("/orders")
    public Iterable<Order> getAllOrders() {
        log.info("Get all orders");
        return orderRepository.findAll();
    }

    @PostMapping("/orders/{username}")
    public Order createOrder(@RequestBody Order order, @PathVariable String username) {
        // User
        User user = userRepository.findById(username)
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + order.getUser().getUsername())));
        order.setUser(user);

        // Delivery
        Delivery delivery = deliveryRepository.findById(order.getDelivery().getDeliveryId())
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Delivery not found with deliveryId: " + order.getDelivery().getDeliveryId())));
        order.setDelivery(delivery);

        // Id
        order.setOrderId(orderRepository.generateOrderId());

        log.info("Create order: {}", order);
        return orderRepository.save(order);
    }

    @GetMapping("/orders/{id}")
    public ResponseEntity<Order> getOrderById(@PathVariable String id) {
        Order order = orderRepository.findById(id)
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found with id: " + id)));

        log.info("Get order by id: {}", id);
        return ResponseEntity.ok(order);
    }

    @GetMapping("/orders/username/{username}")
    public Iterable<Order> getOrderByUsername(@PathVariable String username) {
        User user = userRepository.findById(username)
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username)));

        log.info("Get order by username: {}", username);
        return orderRepository.findAllByUser(user);
    }

    //    Update brand
    @PutMapping("/orders/{username}/{id}")
    public ResponseEntity<Order> updateOrder(@PathVariable String id, @RequestBody Order order, @PathVariable String username) {
        Order _order = orderRepository.findById(id)
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found with id: " + id)));
        order.setOrderId(_order.getOrderId());

        if (order.getUser().getUsername().equals(username)) {
            User user = userRepository.findById(username)
                    .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username)));
            order.setUser(user);

            log.info("Update order: {}", order);
            return ResponseEntity.ok(orderRepository.save(order));
        } else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You don't have permission to update this order");
        }
    }


    @DeleteMapping("/orders/{id}")
    public ResponseEntity<Order> deleteCoupon(@PathVariable String id) {
        Order order = orderRepository.findById(id)
                .orElseThrow((() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found with id: " + id)));
        orderRepository.delete(order);

        log.info("Delete order: {}", order);
        return ResponseEntity.ok(order);
    }
}
