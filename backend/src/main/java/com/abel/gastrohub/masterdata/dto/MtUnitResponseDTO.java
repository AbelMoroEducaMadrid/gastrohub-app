package com.abel.gastrohub.masterdata.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MtUnitResponseDTO {
    // Getters y Setters
    private Integer id;
    private String name;
    private String symbol;

    // Constructor
    public MtUnitResponseDTO(Integer id, String name, String symbol) {
        this.id = id;
        this.name = name;
        this.symbol = symbol;
    }

}