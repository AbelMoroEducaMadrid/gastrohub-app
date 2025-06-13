package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.OrderItemState;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UpdateOrderItemStateDTO {
    private OrderItemState newState;

}