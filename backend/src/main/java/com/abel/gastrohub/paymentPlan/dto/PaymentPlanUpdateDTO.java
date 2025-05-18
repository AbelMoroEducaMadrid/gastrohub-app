package com.abel.gastrohub.paymentPlan.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class PaymentPlanUpdateDTO {
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    private String description;

    private BigDecimal monthlyPrice;

    private Integer yearlyDiscount;

    private Integer maxUsers;
}