package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.OrderState;
import com.abel.gastrohub.order.PaymentMethod;
import com.abel.gastrohub.order.PaymentState;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderUpdateDTO {

    private String notes;

    private Boolean urgent;

    private OrderState state;

    private PaymentState paymentState;

    private PaymentMethod paymentMethod;

    private List<OrderItemDTO> items;
}