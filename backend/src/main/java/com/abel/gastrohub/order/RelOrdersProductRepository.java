package com.abel.gastrohub.order;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RelOrdersProductRepository extends JpaRepository<RelOrdersProduct, Integer> {

    List<RelOrdersProduct> findByOrderId(Integer orderId);
}