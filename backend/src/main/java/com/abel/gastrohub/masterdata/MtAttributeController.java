package com.abel.gastrohub.masterdata;

import com.abel.gastrohub.masterdata.dto.MtAttributeResponseDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/attributes")
public class MtAttributeController {

    private final MtAttributeService attributeService;

    public MtAttributeController(MtAttributeService attributeService) {
        this.attributeService = attributeService;
    }

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<MtAttributeResponseDTO>> getAllAttributes() {
        List<MtAttribute> attributes = attributeService.getAllAttributes();
        List<MtAttributeResponseDTO> dtos = attributes.stream()
                .map(attr -> new MtAttributeResponseDTO(attr.getId(), attr.getName(), attr.getDescription()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtAttributeResponseDTO> getAttributeById(@PathVariable Integer id) {
        MtAttribute attr = attributeService.getAttributeById(id);
        MtAttributeResponseDTO dto = new MtAttributeResponseDTO(attr.getId(), attr.getName(), attr.getDescription());
        return ResponseEntity.ok(dto);
    }
}