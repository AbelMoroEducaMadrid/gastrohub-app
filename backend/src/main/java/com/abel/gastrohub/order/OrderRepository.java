package com.abel.gastrohub.order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    List<Order> findByRestaurantId(Integer restaurantId);

    List<Order> findByTableId(Integer tableId);

    List<Order> findByState(OrderState state);

    List<Order> findByRestaurantIdAndTableIsNull(Integer restaurantId);
}