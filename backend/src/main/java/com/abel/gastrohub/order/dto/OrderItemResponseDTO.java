package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.OrderItemState;
import com.abel.gastrohub.order.RelOrdersProduct;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
public class OrderItemResponseDTO {

    private Integer id;
    private Integer productId;
    private BigDecimal price;
    private String notes;
    private OrderItemState state;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public OrderItemResponseDTO(RelOrdersProduct item) {
        this.id = item.getId();
        this.productId = item.getProduct().getId();
        this.price = item.getPrice();
        this.notes = item.getNotes();
        this.state = item.getState();
        this.createdAt = item.getCreatedAt();
        this.updatedAt = item.getUpdatedAt();
    }
}