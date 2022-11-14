package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Category;
import com.hcmute.backendtechnologicalapplianceswebsite.repository.CategoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class CategoryController {
    private final CategoryRepository categoryRepository;

    public CategoryController(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    // Get All Categories
    @GetMapping("/categories")
    public Iterable<Category> getAllCategories() {
        log.info("Get all categories");
        return categoryRepository.findAll();
    }

    //    Create category
    @PostMapping("/categories")
    public Category createCategory(@RequestBody Category category) {
    //  Default value for categoryId
        category.setCategoryId(categoryRepository.generateCategoryId());

        log.info("Create category: {}", category);
        return categoryRepository.save(category);
    }

    //    Get category by id
    @GetMapping("/categories/{id}")
    public ResponseEntity<Category> getCategoryById(@PathVariable String id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Category not found with id " + id));

        log.info("Get category by id: " + id);
        return ResponseEntity.ok(category);
    }

    //    Update category
    @PutMapping("/categories/{id}")
    public ResponseEntity<Category> updateCategory(@PathVariable String id, @RequestBody Category category) {
        Category _category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Category not found with id " + id));
        _category.setName(category.getName());
        categoryRepository.save(_category);

        log.info("Update category by id: " + id);
        return ResponseEntity.ok(_category);
    }

    //    Delete category
    @DeleteMapping("/categories/{id}")
    public ResponseEntity<Category> deleteCategory(@PathVariable String id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Category not found with id " + id));
        categoryRepository.delete(category);

        log.info("Delete category by id: " + id);
        return ResponseEntity.ok(category);
    }

}
