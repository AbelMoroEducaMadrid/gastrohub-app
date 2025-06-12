package com.abel.gastrohub.product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RelProductsIngredientRepository extends JpaRepository<RelProductsIngredient, RelProductsIngredientId> {
    List<RelProductsIngredient> findByProductId(Integer productId);
}