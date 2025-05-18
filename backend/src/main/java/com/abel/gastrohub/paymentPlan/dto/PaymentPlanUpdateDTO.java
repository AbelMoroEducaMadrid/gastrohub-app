package com.abel.gastrohub.paymentPlan.dto;

import com.abel.gastrohub.paymentPlan.BillingCycle;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class PaymentPlanUpdateDTO {
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    private String description;

    private Float price;

    private BillingCycle billingCycle;

    private Integer maxUsers;

    private Boolean isVisible;
}