package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.OrderState;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateOrderStateDTO {
    private OrderState newState;
}