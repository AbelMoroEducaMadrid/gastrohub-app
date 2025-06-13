package com.abel.gastrohub.order.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class OrderItemDTO {

    @NotNull(message = "El productId no puede ser nulo")
    private Integer productId;

    @NotNull(message = "La cantidad no puede ser nula")
    @Positive(message = "La cantidad debe ser positiva")
    private Integer quantity;

    @NotNull(message = "El precio no puede ser nulo")
    private BigDecimal price;

    private String notes;
}