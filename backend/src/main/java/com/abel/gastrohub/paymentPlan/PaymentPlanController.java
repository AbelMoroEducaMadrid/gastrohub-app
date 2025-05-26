package com.abel.gastrohub.paymentPlan;

import com.abel.gastrohub.paymentPlan.dto.PaymentPlanResponseDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/payment-plans")
public class PaymentPlanController {

    private final PaymentPlanService paymentPlanService;

    public PaymentPlanController(PaymentPlanService paymentPlanService) {
        this.paymentPlanService = paymentPlanService;
    }

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public List<PaymentPlanResponseDTO> getAllPaymentPlans() {
        return paymentPlanService.getAllPaymentPlans().stream()
                .map(PaymentPlanResponseDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<PaymentPlanResponseDTO> getPaymentPlanById(@PathVariable Integer id) {
        PaymentPlan paymentPlan = paymentPlanService.getPaymentPlanById(id);
        return ResponseEntity.ok(new PaymentPlanResponseDTO(paymentPlan));
    }
}