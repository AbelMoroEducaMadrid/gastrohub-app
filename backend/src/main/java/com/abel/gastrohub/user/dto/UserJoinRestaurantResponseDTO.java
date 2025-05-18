package com.abel.gastrohub.user.dto;

import com.abel.gastrohub.user.User;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserJoinRestaurantResponseDTO {
    private int restaurantId;

    public UserJoinRestaurantResponseDTO(User user) {
        this.restaurantId = user.getRestaurant().getId();
    }
}