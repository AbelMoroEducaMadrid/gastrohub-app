package com.abel.gastrohub.masterdata;

import com.abel.gastrohub.masterdata.dto.MtUnitResponseDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/units")
public class MtUnitController {

    private final MtUnitService unitService;

    public MtUnitController(MtUnitService unitService) {
        this.unitService = unitService;
    }

    @GetMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<MtUnitResponseDTO>> getAllUnits() {
        List<MtUnit> units = unitService.getAllUnits();
        List<MtUnitResponseDTO> dtos = units.stream()
                .map(unit -> new MtUnitResponseDTO(unit.getId(), unit.getName(), unit.getSymbol()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<MtUnitResponseDTO> getUnitById(@PathVariable Integer id) {
        MtUnit unit = unitService.getUnitById(id);
        MtUnitResponseDTO dto = new MtUnitResponseDTO(unit.getId(), unit.getName(), unit.getSymbol());
        return ResponseEntity.ok(dto);
    }
}