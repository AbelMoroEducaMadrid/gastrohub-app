package com.abel.gastrohub.layout;

import com.abel.gastrohub.layout.dto.LayoutCreateDTO;
import com.abel.gastrohub.layout.dto.LayoutResponseDTO;
import com.abel.gastrohub.layout.dto.LayoutUpdateDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/layouts")
public class LayoutController {

    private final LayoutService layoutService;

    public LayoutController(LayoutService layoutService) {
        this.layoutService = layoutService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SYSTEM', 'OWNER', 'MANAGER')")
    public ResponseEntity<List<LayoutResponseDTO>> getAllLayoutsByRestaurant() {
        List<Layout> layouts = layoutService.getAllLayoutsByRestaurant();
        List<LayoutResponseDTO> dtos = layouts.stream()
                .map(LayoutResponseDTO::new)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SYSTEM', 'OWNER', 'MANAGER')")
    public ResponseEntity<LayoutResponseDTO> getLayoutById(@PathVariable Integer id) {
        Layout layout = layoutService.getLayoutById(id);
        LayoutResponseDTO dto = new LayoutResponseDTO(layout);
        return ResponseEntity.ok(dto);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'SYSTEM', 'OWNER', 'MANAGER')")
    public ResponseEntity<LayoutResponseDTO> createLayout(@RequestBody LayoutCreateDTO layoutDTO) {
        Layout createdLayout = layoutService.createLayout(layoutDTO);
        LayoutResponseDTO dto = new LayoutResponseDTO(createdLayout);
        return ResponseEntity.status(201).body(dto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SYSTEM', 'OWNER', 'MANAGER')")
    public ResponseEntity<LayoutResponseDTO> updateLayout(@PathVariable Integer id, @RequestBody LayoutUpdateDTO layoutDTO) {
        Layout updatedLayout = layoutService.updateLayout(id, layoutDTO);
        LayoutResponseDTO dto = new LayoutResponseDTO(updatedLayout);
        return ResponseEntity.ok(dto);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'SYSTEM', 'OWNER', 'MANAGER')")
    public ResponseEntity<LayoutResponseDTO> deleteLayout(@PathVariable Integer id) {
        Layout deletedLayout = layoutService.deleteLayout(id);
        LayoutResponseDTO dto = new LayoutResponseDTO(deletedLayout);
        return ResponseEntity.ok(dto);
    }
}