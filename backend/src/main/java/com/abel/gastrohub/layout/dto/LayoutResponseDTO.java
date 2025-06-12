package com.abel.gastrohub.layout.dto;

import com.abel.gastrohub.layout.Layout;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LayoutResponseDTO {

    private Integer id;

    private String name;

    public LayoutResponseDTO(Layout layout) {
        this.id = layout.getId();
        this.name = layout.getName();
    }
}