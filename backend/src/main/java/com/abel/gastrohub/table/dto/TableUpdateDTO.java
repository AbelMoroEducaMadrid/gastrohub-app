package com.abel.gastrohub.table.dto;

import com.abel.gastrohub.table.TableState;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TableUpdateDTO {

    @Positive(message = "El número de mesa debe ser positivo")
    private Integer number;

    @Positive(message = "La capacidad debe ser positiva")
    private Integer capacity;

    private TableState state;

}