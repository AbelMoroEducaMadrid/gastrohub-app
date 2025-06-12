package com.abel.gastrohub.product.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class IngredientAdditionDTO {
    private Integer ingredientId;
    private BigDecimal quantity;

}