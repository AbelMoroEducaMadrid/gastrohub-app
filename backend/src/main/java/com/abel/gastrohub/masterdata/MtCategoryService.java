package com.abel.gastrohub.masterdata;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class MtCategoryService {

    private final MtCategoryRepository categoryRepository;

    public MtCategoryService(MtCategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<MtCategory> getAllCategories() {
        return categoryRepository.findAll();
    }

    public MtCategory getCategoryById(Integer id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Categoría no encontrada con ID: " + id));
    }

    public MtCategory getCategoryByName(String name) {
        return categoryRepository.findByName(name)
                .orElseThrow(() -> new NoSuchElementException("Categoría no encontrada con nombre: " + name));
    }
}