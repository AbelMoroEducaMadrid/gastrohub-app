package com.abel.gastrohub.ingredient;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IngredientRepository extends JpaRepository<Ingredient, Integer> {
    List<Ingredient> findByRestaurantId(Integer restaurantId);
    List<Ingredient> findByRestaurantIdAndIsComposite(Integer restaurantId, Boolean isComposite);
    boolean existsByIdAndParentIngredientsNotEmpty(Integer id);
}