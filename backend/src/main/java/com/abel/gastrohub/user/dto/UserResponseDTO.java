package com.abel.gastrohub.user.dto;

import com.abel.gastrohub.user.User;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Setter
@Getter
public class UserResponseDTO {
    private Integer id;
    private String name;
    private String email;
    private String phone;
    private String role;
    private Integer restaurantId;
    private String restaurantName;
    private LocalDateTime lastLogin;

    // Constructor para JPQL
    public UserResponseDTO(Integer id, String name, String email, String phone, String role,
                           Integer restaurantId, String restaurantName, LocalDateTime lastLogin) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.lastLogin = lastLogin;
    }

    public UserResponseDTO(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.phone = user.getPhone();
        this.role = user.getRole().getName();
        this.restaurantId = user.getRestaurant() != null ? user.getRestaurant().getId() : null;
        this.lastLogin = user.getLastLogin();
    }
}