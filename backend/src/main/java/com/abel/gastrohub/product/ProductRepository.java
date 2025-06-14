package com.abel.gastrohub.product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findByRestaurantId(Integer restaurantId);
    Optional<Product> findByIdAndRestaurantId(Integer id, Integer restaurantId);
}