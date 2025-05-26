package com.abel.gastrohub.ingredient.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class IngredientListDTO {
    private Integer id;
    private String name;
    private Boolean isComposite;
}