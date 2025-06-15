package com.abel.gastrohub.order.dto;

import com.abel.gastrohub.order.PaymentMethod;
import com.abel.gastrohub.order.PaymentState;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdatePaymentDTO {
    private PaymentState paymentState;
    private PaymentMethod paymentMethod;
}