package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.CartDetail;
import com.hcmute.backendtechnologicalapplianceswebsite.model.CartDetailId;
import com.hcmute.backendtechnologicalapplianceswebsite.model.Product;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.CartDetailRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.ProductRepository;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class CartDetailController {
    private final CartDetailRepository cartDetailRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public CartDetailController(CartDetailRepository cartDetailRepository, UserRepository userRepository, ProductRepository productRepository) {
        this.cartDetailRepository = cartDetailRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
    }


    @GetMapping("/cart-details/{username}")
    public ResponseEntity<List<CartDetail>> getCartDetails(@PathVariable String username) {
        List<CartDetail> cartDetails = cartDetailRepository.findAllById_Username(username);

        for (CartDetail cartDetail : cartDetails) {
            Product product = productRepository.findById(cartDetail.getId().getProductId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found with id: " + cartDetail.getId().getProductId()));
            if (product.getQuantity() < cartDetail.getQuantity()) {
                if (product.getQuantity() == 0) {
                    log.warn("Quantity of product: {} is 0, remove product from cart", product.getName());
                    cartDetailRepository.deleteById(cartDetail.getId());
                } else {
                    log.warn("Quantity of product: {} is not enough (in cart: {} > in product: {})",
                            product.getName(), cartDetail.getQuantity(), product.getQuantity());
                    log.info("Set quantity of product: {} to quantity in product: {}", product.getName(), product.getQuantity());
                    cartDetail.setQuantity(product.getQuantity());
                    cartDetailRepository.save(cartDetail);
                }
            }
        }

        log.info("Get all cart details of user: {}", username);
        return ResponseEntity.ok(cartDetails);
    }

    @PostMapping("/cart-details/{username}/{productId}")
    public CartDetail createCartDetail(@RequestBody CartDetail cartDetail, @PathVariable String username, @PathVariable String productId) {
        CartDetailId cartDetailId = new CartDetailId(username, productId);

        if (cartDetailRepository.existsById(cartDetailId)) {
            CartDetail newCartDetail = cartDetailRepository.findById(cartDetailId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "CartDetail not found with id: " + cartDetail.getId()));
            newCartDetail.setQuantity(newCartDetail.getQuantity() + cartDetail.getQuantity());

            log.info("CartDetail is existed, update quantity of cart detail: {}", cartDetailId);
            return cartDetailRepository.save(newCartDetail);
        } else {
            User user = userRepository.findById(username)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with id: " + cartDetail.getId().getUsername()));
            Product product = productRepository.findById(productId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found with id: " + cartDetail.getId().getProductId()));
            cartDetail.setUser(user);
            cartDetail.setProduct(product);
            cartDetail.setId(cartDetailId);

            log.info("Create new cart detail: {}", cartDetail.getId());
            return cartDetailRepository.save(cartDetail);
        }
    }

    @GetMapping("/cart-details/{username}/{productId}")
    public ResponseEntity<CartDetail> getCartDetail(@PathVariable String username, @PathVariable String productId) {
        CartDetailId cartDetailId = new CartDetailId(username, productId);
        CartDetail cartDetail = cartDetailRepository.findById(cartDetailId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cart not found with id: " + cartDetailId));

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found with id: " + productId));

        if (product.getQuantity() < cartDetail.getQuantity()) {
            if (product.getQuantity() == 0) {
                log.warn("Quantity of product: {} is 0, remove product from cart", product.getName());
                cartDetailRepository.deleteById(cartDetail.getId());
            } else {
                log.warn("Quantity of product: {} is not enough (in cart: {} > in product: {})",
                        product.getName(), cartDetail.getQuantity(), product.getQuantity());
                log.info("Set quantity of product: {} to quantity in product: {}", product.getName(), product.getQuantity());
                cartDetail.setQuantity(product.getQuantity());
                cartDetailRepository.save(cartDetail);
            }
        }

        log.info("Get cart detail: {}", cartDetailId);
        return ResponseEntity.ok(cartDetail);
    }

    @PutMapping("/cart-details/{username}/{productId}")
    public CartDetail updateCartDetail(@RequestBody CartDetail data, @PathVariable String username, @PathVariable String productId) {
        CartDetailId cartDetailId = new CartDetailId(username, productId);
        CartDetail cartDetail = cartDetailRepository.findById(cartDetailId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cart not found with id: " + cartDetailId));
        cartDetail.setQuantity(data.getQuantity());

        log.info("Update cart detail: {}", cartDetailId);
        return cartDetailRepository.save(cartDetail);
    }


    @DeleteMapping("/cart-details/{username}/{productId}")
    public ResponseEntity<CartDetail> deleteCartDetail(@PathVariable String username, @PathVariable String productId) {
        CartDetailId cartDetailId = new CartDetailId(username, productId);
        CartDetail cartDetail = cartDetailRepository.findById(cartDetailId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cart not found with id: " + cartDetailId));
        cartDetailRepository.delete(cartDetail);

        log.info("Delete cart detail: {}", cartDetailId);
        return ResponseEntity.ok(cartDetail);
    }

}
