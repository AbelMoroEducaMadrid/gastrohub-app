package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.OrderItemState;
import com.abel.gastrohub.order.RelOrdersProduct;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class OrderItemResponseDTO {

    private Integer id;
    private Integer productId;
    private String product;
    private BigDecimal price;
    private String notes;
    private OrderItemState state;

    public OrderItemResponseDTO(RelOrdersProduct item) {
        this.id = item.getId();
        this.productId = item.getProduct().getId();
        this.product = item.getProduct().getName();
        this.price = item.getPrice();
        this.notes = item.getNotes();
        this.state = item.getState();
    }
}