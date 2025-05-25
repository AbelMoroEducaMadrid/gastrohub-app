package com.abel.gastrohub.layout.dto;

import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LayoutUpdateDTO {

    @Size(max = 100, message = "El nombre no puede exceder los 100 caracteres")
    private String name;

}