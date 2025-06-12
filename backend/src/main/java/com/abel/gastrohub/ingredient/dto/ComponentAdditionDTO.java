package com.abel.gastrohub.ingredient.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class ComponentAdditionDTO {
    private Integer componentIngredientId;
    private BigDecimal quantity;
    private Integer unitId;
}