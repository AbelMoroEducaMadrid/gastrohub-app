package com.abel.gastrohub.ingredient.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
public class IngredientCreateDTO {
    @NotBlank(message = "El nombre es obligatorio")
    private String name;

    @NotNull(message = "El unitId es obligatorio")
    private Integer unitId;

    @NotNull(message = "El stock es obligatorio")
    @PositiveOrZero(message = "El stock debe ser mayor o igual a cero")
    private BigDecimal stock;

    @PositiveOrZero(message = "El costPerUnit debe ser mayor o igual a cero")
    private BigDecimal costPerUnit;

    @PositiveOrZero(message = "El minStock debe ser mayor o igual a cero")
    private BigDecimal minStock;

    @NotNull(message = "isComposite es obligatorio")
    private Boolean isComposite;

    private List<ComponentDTO> components; // Opcional, solo si isComposite es true

    @Setter
    @Getter
    public static class ComponentDTO {
        @NotNull(message = "El componentIngredientId es obligatorio")
        private Integer componentIngredientId;

        @NotNull(message = "La cantidad es obligatoria")
        @Positive(message = "La cantidad debe ser mayor que cero")
        private BigDecimal quantity;

        @NotNull(message = "El unitId es obligatorio")
        private Integer unitId;
    }
}