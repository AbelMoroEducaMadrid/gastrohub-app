package com.abel.gastrohub.paymentPlan.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class PaymentPlanRegistrationDTO {
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    @NotNull(message = "La descripción no puede ser nula")
    private String description;

    @NotNull(message = "El precio mensual no puede ser nulo")
    private BigDecimal monthlyPrice;

    @NotNull(message = "El descuento anual no puede ser nulo")
    private Integer yearlyDiscount;

    private Integer maxUsers;
}