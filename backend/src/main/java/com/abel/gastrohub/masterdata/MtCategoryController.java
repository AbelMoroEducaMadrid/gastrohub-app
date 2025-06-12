package com.abel.gastrohub.masterdata;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class MtCategoryController {

    private final MtCategoryService categoryService;

    public MtCategoryController(MtCategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<MtCategory>> getAllCategories() {
        List<MtCategory> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(categories);
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtCategory> getCategoryById(@PathVariable Integer id) {
        MtCategory category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(category);
    }
}