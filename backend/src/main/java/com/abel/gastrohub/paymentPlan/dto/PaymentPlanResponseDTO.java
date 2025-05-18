package com.abel.gastrohub.paymentPlan.dto;

import com.abel.gastrohub.paymentPlan.BillingCycle;
import com.abel.gastrohub.paymentPlan.PaymentPlan;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class PaymentPlanResponseDTO {
    private Integer id;
    private String name;
    private String description;
    private Float price;
    private BillingCycle billingCycle;
    private Integer maxUsers;
    private Boolean isVisible;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    public PaymentPlanResponseDTO(PaymentPlan paymentPlan) {
        this.id = paymentPlan.getId();
        this.name = paymentPlan.getName();
        this.description = paymentPlan.getDescription();
        this.price = paymentPlan.getPrice();
        this.billingCycle = paymentPlan.getBillingCycle();
        this.maxUsers = paymentPlan.getMaxUsers();
        this.isVisible = paymentPlan.getIsVisible();
        this.createdAt = paymentPlan.getCreatedAt();
        this.updatedAt = paymentPlan.getUpdatedAt();
        this.deletedAt = paymentPlan.getDeletedAt();
    }
}