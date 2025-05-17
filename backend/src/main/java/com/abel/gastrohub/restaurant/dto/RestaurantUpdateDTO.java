package com.abel.gastrohub.restaurant.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class RestaurantUpdateDTO {
    // Getters y setters
    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    private String address;

    private String cuisineType;

    private String description;

}