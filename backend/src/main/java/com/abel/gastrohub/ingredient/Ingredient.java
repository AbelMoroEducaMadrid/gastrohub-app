package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.masterdata.MtAttribute;
import com.abel.gastrohub.masterdata.MtUnit;
import com.abel.gastrohub.restaurant.Restaurant;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "ingredients")
public class Ingredient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @Size(max = 255)
    @NotNull
    @Column(name = "name", nullable = false)
    private String name;

    @NotNull
    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "unit_id", nullable = false)
    private MtUnit unit;

    @NotNull
    @Column(name = "stock", nullable = false, precision = 10, scale = 2)
    private BigDecimal stock;

    @NotNull
    @Column(name = "cost_per_unit", nullable = false, precision = 10, scale = 2)
    private BigDecimal costPerUnit;

    @Column(name = "min_stock", precision = 10, scale = 2)
    private BigDecimal minStock;

    @NotNull
    @ColumnDefault("false")
    @Column(name = "is_composite", nullable = false)
    private Boolean isComposite = false;

    @NotNull
    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @NotNull
    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @ManyToMany
    @JoinTable(
            name = "rel_ingredients_attributes",
            joinColumns = @JoinColumn(name = "ingredient_id"),
            inverseJoinColumns = @JoinColumn(name = "attribute_id")
    )
    private Set<MtAttribute> attributes = new HashSet<>();

    @OneToMany(mappedBy = "parentIngredient", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private Set<RelIngredientIngredient> relIngredientIngredients = new LinkedHashSet<>();

    @OneToMany(mappedBy = "componentIngredient")
    private Set<RelIngredientIngredient> parentIngredients = new LinkedHashSet<>();

    @PrePersist
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

}