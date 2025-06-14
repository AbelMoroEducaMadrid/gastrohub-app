package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.Order;
import com.abel.gastrohub.order.OrderState;
import com.abel.gastrohub.order.PaymentMethod;
import com.abel.gastrohub.order.PaymentState;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderResponseDTO {

    private Integer id;
    private Integer tableId;
    private Integer tableNumber;
    private String layout;
    private String notes;
    private Boolean urgent;
    private OrderState state;
    private PaymentState paymentState;
    private PaymentMethod paymentMethod;
    private List<OrderItemResponseDTO> items;

    public OrderResponseDTO(Order order) {
        this.id = order.getId();
        if(order.getTable() != null) {
            this.tableId = order.getTable().getId();
            this.tableNumber = order.getTable().getNumber();
            this.layout =order.getTable().getLayout().getName();
        }
        this.notes = order.getNotes();
        this.urgent = order.getUrgent();
        this.state = order.getState();
        this.paymentState = order.getPaymentState();
        this.paymentMethod = order.getPaymentMethod();
    }
}