package com.abel.gastrohub.restaurant.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class RestaurantRegistrationDTO {

    // Getters y setters
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    private String address;

    private String cuisineType;

    private String description;

    @NotNull(message = "El ID del plan de pago no puede ser nulo")
    private Integer paymentPlanId;
}