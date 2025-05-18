package com.abel.gastrohub.paymentPlan;

import com.abel.gastrohub.paymentPlan.dto.PaymentPlanRegistrationDTO;
import com.abel.gastrohub.paymentPlan.dto.PaymentPlanResponseDTO;
import com.abel.gastrohub.paymentPlan.dto.PaymentPlanUpdateDTO;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/payment-plans")
public class PaymentPlanController {

    private final PaymentPlanService paymentPlanService;

    @Autowired
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

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<PaymentPlanResponseDTO> createPaymentPlan(@Valid @RequestBody PaymentPlanRegistrationDTO paymentPlanDTO) {
        PaymentPlan paymentPlan = new PaymentPlan();
        paymentPlan.setName(paymentPlanDTO.getName());
        paymentPlan.setDescription(paymentPlanDTO.getDescription());
        paymentPlan.setMonthlyPrice(paymentPlanDTO.getMonthlyPrice());
        paymentPlan.setYearlyDiscount(paymentPlanDTO.getYearlyDiscount());
        paymentPlan.setMaxUsers(paymentPlanDTO.getMaxUsers());
        PaymentPlan savedPaymentPlan = paymentPlanService.createPaymentPlan(paymentPlan);
        return ResponseEntity.status(201).body(new PaymentPlanResponseDTO(savedPaymentPlan));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<PaymentPlanResponseDTO> updatePaymentPlan(@PathVariable Integer id, @Valid @RequestBody PaymentPlanUpdateDTO paymentPlanDTO) {
        PaymentPlan paymentPlan = paymentPlanService.getPaymentPlanById(id);
        paymentPlan.setName(paymentPlanDTO.getName());
        paymentPlan.setDescription(paymentPlanDTO.getDescription());
        paymentPlan.setMonthlyPrice(paymentPlanDTO.getMonthlyPrice());
        paymentPlan.setYearlyDiscount(paymentPlanDTO.getYearlyDiscount());
        paymentPlan.setMaxUsers(paymentPlanDTO.getMaxUsers());
        PaymentPlan updatedPaymentPlan = paymentPlanService.updatePaymentPlan(id, paymentPlan);
        return ResponseEntity.ok(new PaymentPlanResponseDTO(updatedPaymentPlan));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<PaymentPlanResponseDTO> deletePaymentPlan(@PathVariable Integer id) {
        PaymentPlan deletedPaymentPlan = paymentPlanService.deletePaymentPlan(id);
        return ResponseEntity.ok(new PaymentPlanResponseDTO(deletedPaymentPlan));
    }
}