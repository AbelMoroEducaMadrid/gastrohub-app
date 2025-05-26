package com.abel.gastrohub.masterdata;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/attributes")
public class MtAttributeController {

    private final MtAttributeService attributeService;

    public MtAttributeController(MtAttributeService attributeService) {
        this.attributeService = attributeService;
    }

    // Obtener todos los atributos
    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<MtAttribute>> getAllAttributes() {
        return ResponseEntity.ok(attributeService.getAllAttributes());
    }

    // Obtener un atributo por ID
    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtAttribute> getAttributeById(@PathVariable Integer id) {
        return ResponseEntity.ok(attributeService.getAttributeById(id));
    }

    // Obtener un atributo por nombre
    @GetMapping("/name/{name}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtAttribute> getAttributeByName(@PathVariable String name) {
        return ResponseEntity.ok(attributeService.getAttributeByName(name));
    }
}