package com.abel.gastrohub.ingredient;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RelIngredientIngredientRepository extends JpaRepository<RelIngredientIngredient, RelIngredientIngredientId> {
    List<RelIngredientIngredient> findByParentIngredientId(Integer parentIngredientId);
}