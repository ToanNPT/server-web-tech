package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class UserController {
    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Get All Users
    @GetMapping("/users")
    public Iterable<User> getAllUsers() {
        log.info("Get all users");
        return userRepository.findAll();
    }

    //    Create user
    @Transactional
    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        log.info("Create user: " + user);
        return userRepository.save(user);
    }

    //    Get user by username
    @GetMapping("/users/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        User user =  userRepository.findById(username).
                orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username));

        log.info("Get user by username: " + username);
        return ResponseEntity.ok(user);
    }

    //    Update user
    @Transactional
    @PutMapping("/users/{username}")
    public ResponseEntity<User> updateUser(@PathVariable String username, @RequestBody User user) {
        User _user = userRepository.findById(username).
                orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username));
        _user.setName(user.getName());
        _user.setEmail(user.getEmail());
        _user.setPhoneNumber(user.getPhoneNumber());
        _user.setAddress(user.getAddress());
        _user.setDateOfBirth(user.getDateOfBirth());
        _user.setGender(user.getGender());
        userRepository.save(_user);

        log.info("Update user: " + _user);
        return ResponseEntity.ok(_user);
    }

    //    Delete user
    @Transactional
    @DeleteMapping("/users/{username}")
    public ResponseEntity<User> deleteUser(@PathVariable String username) {
        User user = userRepository.findById(username).
                orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found with username: " + username));

        userRepository.deleteByUsername(username);
        log.info("Delete user: " + user);
        return ResponseEntity.ok(user);
    }

}
