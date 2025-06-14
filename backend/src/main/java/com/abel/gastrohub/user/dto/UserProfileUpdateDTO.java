package com.abel.gastrohub.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserProfileUpdateDTO {

    @NotBlank(message = "El nombre no puede estar vacío")
    private String name;

    @Email(message = "El email debe tener un formato válido")
    private String email;

    @Pattern(regexp = "\\d{9}", message = "El teléfono debe tener 9 dígitos")
    private String phone;

}