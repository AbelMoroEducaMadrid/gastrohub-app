package com.abel.gastrohub.dto;

import com.abel.gastrohub.entity.User;

import java.time.LocalDateTime;

public class UserResponseDTO {
    private Integer id;
    private String name;
    private String email;
    private String phone;
    private String status;
    private String role;
    private LocalDateTime lastLogin;

    public UserResponseDTO(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.phone = user.getPhone();
        this.status = user.getStatus();
        this.role = user.getRole() != null ? user.getRole().getName() : null;
        this.lastLogin = user.getLastLogin();
    }

    // Getters y setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
}