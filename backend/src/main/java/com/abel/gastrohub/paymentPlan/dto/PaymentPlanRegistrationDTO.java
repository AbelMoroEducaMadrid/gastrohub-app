package com.abel.gastrohub.paymentPlan.dto;

import com.abel.gastrohub.paymentPlan.BillingCycle;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class PaymentPlanRegistrationDTO {
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    @NotNull(message = "La descripción no puede ser nula")
    private String description;

    @NotNull(message = "El precio no puede ser nulo")
    private Float price;

    @NotNull(message = "El ciclo de facturación no puede ser nulo")
    private BillingCycle billingCycle;

    private Integer maxUsers;

    private Boolean isVisible;
}