package com.abel.gastrohub.ingredient.dto;

import com.abel.gastrohub.ingredient.Ingredient;
import com.abel.gastrohub.ingredient.RelIngredientIngredient;
import com.abel.gastrohub.masterdata.MtUnit;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class RelIngredientIngredientDTO {
    private Integer parentIngredientId;
    private Integer componentIngredientId;
    private BigDecimal quantity;
    private Integer unitId;

    public RelIngredientIngredientDTO() {}

    public RelIngredientIngredientDTO(RelIngredientIngredient rel) {
        this.parentIngredientId = rel.getParentIngredient().getId();
        this.componentIngredientId = rel.getComponentIngredient().getId();
        this.quantity = rel.getQuantity();
        this.unitId = rel.getUnit().getId();
    }

    public RelIngredientIngredient toEntity() {
        RelIngredientIngredient rel = new RelIngredientIngredient();
        Ingredient parent = new Ingredient();
        parent.setId(this.parentIngredientId);
        rel.setParentIngredient(parent);
        Ingredient component = new Ingredient();
        component.setId(this.componentIngredientId);
        rel.setComponentIngredient(component);
        rel.setQuantity(this.quantity);
        MtUnit unit = new MtUnit();
        unit.setId(this.unitId);
        rel.setUnit(unit);
        return rel;
    }
}