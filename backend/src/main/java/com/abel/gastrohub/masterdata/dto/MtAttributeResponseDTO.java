package com.abel.gastrohub.masterdata.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MtAttributeResponseDTO {
    // Getters y Setters
    private Integer id;
    private String name;
    private String description;

    // Constructor
    public MtAttributeResponseDTO(Integer id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

}