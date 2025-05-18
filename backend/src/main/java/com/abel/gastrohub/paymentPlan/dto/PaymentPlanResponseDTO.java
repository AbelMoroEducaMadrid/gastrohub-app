package com.abel.gastrohub.paymentPlan.dto;

import com.abel.gastrohub.paymentPlan.PaymentPlan;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Setter
@Getter
public class PaymentPlanResponseDTO {
    private Integer id;
    private String name;
    private String description;
    private BigDecimal monthlyPrice;
    private Integer yearlyDiscount;
    private Integer maxUsers;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    public PaymentPlanResponseDTO(PaymentPlan paymentPlan) {
        this.id = paymentPlan.getId();
        this.name = paymentPlan.getName();
        this.description = paymentPlan.getDescription();
        this.monthlyPrice = paymentPlan.getMonthlyPrice();
        this.yearlyDiscount = paymentPlan.getYearlyDiscount();
        this.maxUsers = paymentPlan.getMaxUsers();
        this.createdAt = paymentPlan.getCreatedAt();
        this.updatedAt = paymentPlan.getUpdatedAt();
        this.deletedAt = paymentPlan.getDeletedAt();
    }
}