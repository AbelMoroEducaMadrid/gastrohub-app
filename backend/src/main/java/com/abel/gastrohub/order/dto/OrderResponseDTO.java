package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.Order;
import com.abel.gastrohub.order.OrderState;
import com.abel.gastrohub.order.PaymentMethod;
import com.abel.gastrohub.order.PaymentState;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
public class OrderResponseDTO {

    private Integer id;
    private Integer restaurantId;
    private Integer tableId;
    private String notes;
    private Boolean urgent;
    private OrderState state;
    private PaymentState paymentState;
    private PaymentMethod paymentMethod;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<OrderItemResponseDTO> items;

    public OrderResponseDTO(Order order) {
        this.id = order.getId();
        this.restaurantId = order.getRestaurant().getId();
        this.tableId = order.getTable() != null ? order.getTable().getId() : null;
        this.notes = order.getNotes();
        this.urgent = order.getUrgent();
        this.state = order.getState();
        this.paymentState = order.getPaymentState();
        this.paymentMethod = order.getPaymentMethod();
        this.createdAt = order.getCreatedAt();
        this.updatedAt = order.getUpdatedAt();
    }
}