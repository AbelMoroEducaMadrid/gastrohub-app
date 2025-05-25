package com.abel.gastrohub.layout;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LayoutRepository extends JpaRepository<Layout, Integer> {
    List<Layout> findByRestaurantIdAndDeletedAtIsNull(Integer restaurantId);

    Optional<Layout> findByIdAndDeletedAtIsNull(Integer id);

    Optional<Layout> findByRestaurantIdAndNameAndDeletedAtIsNull(Integer restaurantId, String name);
}