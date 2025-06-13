package com.abel.gastrohub.ingredient.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
public class IngredientResponseDTO {
    private Integer id;
    private String name;
    private Integer unitId;
    private BigDecimal stock;
    private BigDecimal costPerUnit;
    private BigDecimal minStock;
    private Boolean isComposite;
    private List<ComponentResponseDTO> components;

    @Setter
    @Getter
    public static class ComponentResponseDTO {
        private Integer componentIngredientId;
        private String componentName;
        private BigDecimal quantity;
        private Integer unitId;
    }
}