package com.abel.gastrohub.paymentPlan;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentPlanRepository extends JpaRepository<PaymentPlan, Integer> {

    List<PaymentPlan> findByDeletedAtIsNull();

    Optional<PaymentPlan> findByIdAndDeletedAtIsNull(Integer id);
}