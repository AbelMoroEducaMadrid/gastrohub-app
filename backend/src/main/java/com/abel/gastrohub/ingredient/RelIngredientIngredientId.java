package com.abel.gastrohub.ingredient;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serial;
import java.util.Objects;

@Getter
@Embeddable
public class RelIngredientIngredientId implements java.io.Serializable {
    @Serial
    private static final long serialVersionUID = -4172137193083045735L;
    @NotNull
    @Column(name = "parent_ingredient_id", nullable = false)
    private Integer parentIngredientId;

    @NotNull
    @Column(name = "component_ingredient_id", nullable = false)
    private Integer componentIngredientId;

    public RelIngredientIngredientId() {
    }

    public RelIngredientIngredientId(Integer parentIngredientId, Integer componentIngredientId) {
        this.parentIngredientId = parentIngredientId;
        this.componentIngredientId = componentIngredientId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        RelIngredientIngredientId entity = (RelIngredientIngredientId) o;
        return Objects.equals(this.componentIngredientId, entity.componentIngredientId) &&
                Objects.equals(this.parentIngredientId, entity.parentIngredientId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(componentIngredientId, parentIngredientId);
    }

}