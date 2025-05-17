package com.abel.gastrohub.restaurant.dto;

import jakarta.validation.constraints.NotNull;

public class RestaurantRegistrationDTO {

    @NotNull(message = "El nombre no puede ser nulo")
    private String name;

    private String address;

    private String cuisineType;

    private String description;

    // Getters y setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}