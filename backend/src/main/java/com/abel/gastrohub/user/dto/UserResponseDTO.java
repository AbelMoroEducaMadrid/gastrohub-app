package com.abel.gastrohub.user.dto;

import com.abel.gastrohub.user.User;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class UserResponseDTO {
    // Getters y setters
    private Integer id;
    private String name;
    private String email;
    private String phone;
    private String role;
    private Integer restaurantId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer createdBy;
    private Integer updatedBy;
    private LocalDateTime lastLogin;
    private LocalDateTime deletedAt;

    public UserResponseDTO(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.phone = user.getPhone();
        this.role = user.getRole().getName();
        this.restaurantId = user.getRestaurant() != null ? user.getRestaurant().getId() : null;
        this.createdAt = user.getCreatedAt();
        this.updatedAt = user.getUpdatedAt();
        this.lastLogin = user.getLastLogin();
        this.deletedAt = user.getDeletedAt();
    }

}