package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Account;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Delivery;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Order;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.AccountRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.DeliveryRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.OrderRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.weaver.ast.Or;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class OrderController {
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final DeliveryRepository deliveryRepository;
    private final AccountRepository accountRepository;

    public OrderController(OrderRepository orderRepository, UserRepository userRepository,
                           DeliveryRepository deliveryRepository, AccountRepository accountRepository) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
        this.deliveryRepository = deliveryRepository;
        this.accountRepository = accountRepository;
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

    @PutMapping("/orders/{orderId}/update-shipper/{shipper}")
    public ResponseEntity<?> updateShipperForOrder(@PathVariable("orderId") String id,
                                                       @PathVariable("shipper") String username){
        Optional<Order> order = orderRepository.findById(id);
        if(!order.isPresent())
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("order not found");
        Optional<Account> account = accountRepository.findById(username);
        if(!account.isPresent() || account.get().getRole() != 2)
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("account is not found");
        order.get().setShipper(username);
        order.get().setStatus("delivering");
        Order updated = orderRepository.save(order.get());
        return ResponseEntity.ok(updated);
    }

    @GetMapping("orders/no-shipper")
    public ResponseEntity<?> getOrderNoShipper(){
        List<Order> list = orderRepository.getOrdersNoShipper();
        return ResponseEntity.ok(list);
    }

    @PutMapping("orders/{orderId}/complete-delivery/{shipper}")
    public ResponseEntity<?> updateCompleteDelivery(@PathVariable("orderId") String id,
                                                    @PathVariable("shipper") String username){
        Optional<Order> order = orderRepository.findById(id);
        if(!order.isPresent())
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("order not found");
        Optional<Account> account = accountRepository.findById(username);
        if(!account.isPresent() || account.get().getRole() != 2)
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("account is not found");
        if(account.get().getUsername() != order.get().getShipper())
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("you are not a shipper of order");
        if(order.get().getStatus() == "delivered")
            return ResponseEntity.badRequest().body("You can not update status because order was delivered");

        order.get().setStatus("delivered");
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String current = dateFormat.format(new Date());
        order.get().setDeliveredDate(current);
        Order updated = orderRepository.save(order.get());
        return ResponseEntity.ok(updated);
    }

    @GetMapping("orders/shippers/{shipper}/no-complete")
    public ResponseEntity<?> getOrdersOfShipperNoComplete(@PathVariable("shipper") String username){
        List<Order> list =  orderRepository.getOrdersOfShipperNoComplete(username);
        return ResponseEntity.ok(list);
    }

    @GetMapping("orders/shippers/{shipper}/delivered")
    public ResponseEntity<?> getDeliveredOrderByShipper(@PathVariable("shipper") String username){
        List<Order> list = orderRepository.getDeliveredOrderByShipper(username);
        return ResponseEntity.ok(list);
    }

    @GetMapping("orders/shippers/{shipper}/delivered-today")
    public ResponseEntity<?> getDeliveredToday(@PathVariable("shipper") String username){
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String current = dateFormat.format(new Date());

        //String today = String.valueOf(date.getYear()) + '-' + String.valueOf(date.getMonth() + 1) + '-' + String.valueOf(date.getDate());
        List<Order> list = orderRepository.getDeliveredOfShipperToday(username, current);
        return ResponseEntity.ok(list);
    }

    @PutMapping("orders/{orderId}/shippers/{shipper}/remove-shipper")
    public ResponseEntity<?> removeShipperInOrder(@PathVariable("shipper") String username,
                                                  @PathVariable("orderId") String orderId){
        Optional<Order> order = orderRepository.findById(orderId);
        if(!order.isPresent())
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("order not found");
        Optional<Account> account = accountRepository.findById(username);
        if(!account.isPresent() || account.get().getRole() != 2)
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("account is not found");
//        if(account.get().getUsername() != order.get().getShipper())
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("you are not a shipper of order");

        if(order.get().getStatus().equals("delivered"))
            return ResponseEntity.ok("order was delivered successfully");

        order.get().setShipper(null);
        order.get().setStatus("preparing");
        orderRepository.save(order.get());
        return ResponseEntity.ok("remove shipper in order success");
    }
}
