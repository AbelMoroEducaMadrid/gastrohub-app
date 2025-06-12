package com.abel.gastrohub.table.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TableCreateDTO {

    @NotNull(message = "El layoutId no puede ser nulo")
    private Integer layoutId;

    @NotNull(message = "El número de mesa no puede ser nulo")
    @Positive(message = "El número de mesa debe ser positivo")
    private Integer number;

    @NotNull(message = "La capacidad no puede ser nula")
    @Positive(message = "La capacidad debe ser positiva")
    private Integer capacity;
}