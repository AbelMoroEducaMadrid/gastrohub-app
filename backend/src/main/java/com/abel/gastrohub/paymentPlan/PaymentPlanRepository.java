package com.abel.gastrohub.paymentPlan;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentPlanRepository extends JpaRepository<PaymentPlan, Integer> {

}