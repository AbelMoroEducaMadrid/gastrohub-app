package com.abel.gastrohub.paymentPlan;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class PaymentPlanService {

    private final PaymentPlanRepository paymentPlanRepository;

    public PaymentPlanService(PaymentPlanRepository paymentPlanRepository) {
        this.paymentPlanRepository = paymentPlanRepository;
    }

    public List<PaymentPlan> getAllPaymentPlans() {
        return paymentPlanRepository.findByDeletedAtIsNull();
    }

    public PaymentPlan getPaymentPlanById(Integer id) {
        return paymentPlanRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Plan de pago no encontrado con ID: " + id));
    }
}