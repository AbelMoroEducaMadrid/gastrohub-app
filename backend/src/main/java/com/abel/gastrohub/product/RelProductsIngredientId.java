package com.abel.gastrohub.product;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import org.hibernate.Hibernate;

import java.io.Serial;
import java.util.Objects;

@Getter
@Embeddable
public class RelProductsIngredientId implements java.io.Serializable {
    @Serial
    private static final long serialVersionUID = -4885004031831072310L;
    @NotNull
    @Column(name = "product_id", nullable = false)
    private Integer productId;

    @NotNull
    @Column(name = "ingredient_id", nullable = false)
    private Integer ingredientId;

    public RelProductsIngredientId() {
    }

    public RelProductsIngredientId(Integer productId, Integer ingredientId) {
        this.productId = productId;
        this.ingredientId = ingredientId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        RelProductsIngredientId entity = (RelProductsIngredientId) o;
        return Objects.equals(this.ingredientId, entity.ingredientId) &&
                Objects.equals(this.productId, entity.productId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ingredientId, productId);
    }

}