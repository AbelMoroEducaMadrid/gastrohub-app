package com.abel.gastrohub.order.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderCreateDTO {

    @NotNull(message = "El restaurantId no puede ser nulo")
    private Integer restaurantId;

    private Integer tableId;

    private String notes;

    private Boolean urgent;

    @NotNull(message = "La lista de ítems no puede ser nula")
    private List<OrderItemDTO> items;
}