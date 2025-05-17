package com.abel.gastrohub.restaurant.dto;

import com.abel.gastrohub.restaurant.Restaurant;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class RestaurantResponseDTO {
    // Getters y setters
    private Integer id;
    private String name;
    private String address;
    private String cuisineType;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    public RestaurantResponseDTO(Restaurant restaurant) {
        this.id = restaurant.getId();
        this.name = restaurant.getName();
        this.address = restaurant.getAddress();
        this.cuisineType = restaurant.getCuisineType();
        this.description = restaurant.getDescription();
        this.createdAt = restaurant.getCreatedAt();
        this.updatedAt = restaurant.getUpdatedAt();
        this.deletedAt = restaurant.getDeletedAt();
    }

}