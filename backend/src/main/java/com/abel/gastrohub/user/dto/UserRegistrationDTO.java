package com.abel.gastrohub.user.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserRegistrationDTO {
    // Getters y setters
    private String name;
    private String email;
    private String password;
    private String phone;

}