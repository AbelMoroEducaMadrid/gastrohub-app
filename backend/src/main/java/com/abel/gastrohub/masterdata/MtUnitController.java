package com.abel.gastrohub.masterdata;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/units")
public class MtUnitController {

    private final MtUnitService unitService;

    public MtUnitController(MtUnitService unitService) {
        this.unitService = unitService;
    }

    // Obtener todas las unidades
    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<MtUnit>> getAllUnits() {
        return ResponseEntity.ok(unitService.getAllUnits());
    }

    // Obtener una unidad por ID
    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtUnit> getUnitById(@PathVariable Integer id) {
        return ResponseEntity.ok(unitService.getUnitById(id));
    }

    // Obtener una unidad por nombre
    @GetMapping("/name/{name}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtUnit> getUnitByName(@PathVariable String name) {
        return ResponseEntity.ok(unitService.getUnitByName(name));
    }

    // Obtener una unidad por símbolo
    @GetMapping("/symbol/{symbol}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtUnit> getUnitBySymbol(@PathVariable String symbol) {
        return ResponseEntity.ok(unitService.getUnitBySymbol(symbol));
    }
}