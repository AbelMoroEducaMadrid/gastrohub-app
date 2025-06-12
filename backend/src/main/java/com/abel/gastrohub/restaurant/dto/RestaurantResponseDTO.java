package com.abel.gastrohub.restaurant.dto;

import com.abel.gastrohub.paymentPlan.PaymentPlan;
import com.abel.gastrohub.restaurant.Restaurant;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class RestaurantResponseDTO {
    private Integer id;
    private String name;
    private String address;
    private String cuisineType;
    private String description;
    private String invitationCode;
    private LocalDateTime invitationExpiresAt;
    private Integer paymentPlanId;
    private Boolean paid;

    public RestaurantResponseDTO(Restaurant restaurant) {
        this.id = restaurant.getId();
        this.name = restaurant.getName();
        this.address = restaurant.getAddress();
        this.cuisineType = restaurant.getCuisineType();
        this.description = restaurant.getDescription();
        this.invitationCode = restaurant.getInvitationCode();
        this.invitationExpiresAt = restaurant.getInvitationExpiresAt();
        PaymentPlan paymentPlan = restaurant.getPaymentPlan();
        this.paymentPlanId = paymentPlan != null ? paymentPlan.getId() : null;
        this.paid = restaurant.getPaid();
    }
}