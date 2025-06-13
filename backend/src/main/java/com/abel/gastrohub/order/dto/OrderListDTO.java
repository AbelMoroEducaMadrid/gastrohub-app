package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.Order;
import com.abel.gastrohub.order.OrderState;
import com.abel.gastrohub.order.PaymentMethod;
import com.abel.gastrohub.order.PaymentState;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderListDTO {

    private Integer id;
    private Integer tableId;
    private String notes;
    private Boolean urgent;
    private OrderState state;
    private PaymentState paymentState;
    private PaymentMethod paymentMethod;

    public OrderListDTO(Order order) {
        this.id = order.getId();
        this.tableId = order.getTable() != null ? order.getTable().getId() : null;
        this.notes = order.getNotes();
        this.urgent = order.getUrgent();
        this.state = order.getState();
        this.paymentState = order.getPaymentState();
        this.paymentMethod = order.getPaymentMethod();
    }
}