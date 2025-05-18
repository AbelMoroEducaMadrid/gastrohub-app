package com.abel.gastrohub.paymentPlan;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class PaymentPlanService {

    private final PaymentPlanRepository paymentPlanRepository;

    @Autowired
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

    public PaymentPlan createPaymentPlan(PaymentPlan paymentPlan) {
        return paymentPlanRepository.save(paymentPlan);
    }

    public PaymentPlan updatePaymentPlan(Integer id, PaymentPlan paymentPlanDetails) {
        PaymentPlan paymentPlan = getPaymentPlanById(id);
        paymentPlan.setName(paymentPlanDetails.getName());
        paymentPlan.setDescription(paymentPlanDetails.getDescription());
        paymentPlan.setPrice(paymentPlanDetails.getPrice());
        paymentPlan.setBillingCycle(paymentPlanDetails.getBillingCycle());
        paymentPlan.setMaxUsers(paymentPlanDetails.getMaxUsers());
        paymentPlan.setIsVisible(paymentPlanDetails.getIsVisible());
        return paymentPlanRepository.save(paymentPlan);
    }

    public PaymentPlan deletePaymentPlan(Integer id) {
        PaymentPlan paymentPlan = getPaymentPlanById(id);
        paymentPlan.setDeletedAt(LocalDateTime.now());
        return paymentPlanRepository.save(paymentPlan);
    }

    public List<PaymentPlan> getVisiblePaymentPlans() {
        return paymentPlanRepository.findByIsVisibleTrueAndDeletedAtIsNull();
    }
}