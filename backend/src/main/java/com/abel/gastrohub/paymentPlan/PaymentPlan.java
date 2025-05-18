package com.abel.gastrohub.paymentPlan;

import com.abel.gastrohub.restaurant.Restaurant;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "payment_plans")
public class PaymentPlan {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "payment_plans_id_gen")
    @SequenceGenerator(name = "payment_plans_id_gen", sequenceName = "payment_plans_id_seq", allocationSize = 1)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Size(max = 255)
    @NotNull
    @Column(name = "name", nullable = false)
    private String name;

    @NotNull
    @Column(name = "description", nullable = false, length = Integer.MAX_VALUE)
    private String description;

    @NotNull
    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private Float price;

    @Enumerated(EnumType.STRING)
    @Column(name = "billing_cycle", columnDefinition = "billing_cycle")
    private BillingCycle billingCycle;

    @Column(name = "max_users")
    private Integer maxUsers;

    @ColumnDefault("true")
    @Column(name = "is_visible")
    private Boolean isVisible;

    @NotNull
    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @NotNull
    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "paymentPlan")
    private Set<Restaurant> restaurants = new LinkedHashSet<>();

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