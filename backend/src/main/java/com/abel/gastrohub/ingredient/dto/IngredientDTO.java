package com.abel.gastrohub.ingredient.dto;

import com.abel.gastrohub.ingredient.Ingredient;
import com.abel.gastrohub.masterdata.MtUnit;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class IngredientDTO {
    private Integer id;
    private String name;
    private Integer unitId;
    private BigDecimal stock;
    private BigDecimal costPerUnit;
    private BigDecimal minStock;
    private Boolean isComposite;

    public IngredientDTO() {}

    public IngredientDTO(Ingredient ingredient) {
        this.id = ingredient.getId();
        this.name = ingredient.getName();
        this.unitId = ingredient.getUnit().getId();
        this.stock = ingredient.getStock();
        this.costPerUnit = ingredient.getCostPerUnit();
        this.minStock = ingredient.getMinStock();
        this.isComposite = ingredient.getIsComposite();
    }

    public Ingredient toEntity() {
        Ingredient ingredient = new Ingredient();
        ingredient.setId(this.id);
        ingredient.setName(this.name);
        MtUnit unit = new MtUnit();
        unit.setId(this.unitId);
        ingredient.setUnit(unit);
        ingredient.setStock(this.stock);
        ingredient.setCostPerUnit(this.costPerUnit);
        ingredient.setMinStock(this.minStock);
        ingredient.setIsComposite(this.isComposite);
        return ingredient;
    }
}