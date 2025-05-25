package com.abel.gastrohub.table.dto;

import com.abel.gastrohub.table.Table;
import com.abel.gastrohub.table.TableState;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TableResponseDTO {

    private Integer id;
    private Integer layoutId;
    private Integer number;
    private Integer capacity;
    private TableState state;

    public TableResponseDTO(Table table) {
        this.id = table.getId();
        this.layoutId = table.getLayout().getId();
        this.number = table.getNumber();
        this.capacity = table.getCapacity();
        this.state = table.getState();
    }
}