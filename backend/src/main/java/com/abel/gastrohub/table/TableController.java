package com.abel.gastrohub.table;

import com.abel.gastrohub.table.dto.TableCreateDTO;
import com.abel.gastrohub.table.dto.TableResponseDTO;
import com.abel.gastrohub.table.dto.TableUpdateDTO;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tables")
public class TableController {

    private final TableService tableService;

    public TableController(TableService tableService) {
        this.tableService = tableService;
    }

    @GetMapping("/layout/{layoutId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<List<TableResponseDTO>> getAllTablesByLayout(@PathVariable Integer layoutId) {
        List<TableResponseDTO> tables = tableService.getAllTablesByLayout(layoutId);
        return ResponseEntity.ok(tables);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<TableResponseDTO> getTableById(@PathVariable Integer id) {
        TableResponseDTO table = tableService.getTableById(id);
        return ResponseEntity.ok(table);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<TableResponseDTO> createTable(@Valid @RequestBody TableCreateDTO tableDTO) {
        TableResponseDTO createdTable = tableService.createTable(tableDTO);
        return ResponseEntity.status(201).body(createdTable);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<TableResponseDTO> updateTable(@PathVariable Integer id, @RequestBody TableUpdateDTO tableDTO) {
        TableResponseDTO updatedTable = tableService.updateTable(id, tableDTO);
        return ResponseEntity.ok(updatedTable);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<TableResponseDTO> deleteTable(@PathVariable Integer id) {
        TableResponseDTO deletedTable = tableService.deleteTable(id);
        return ResponseEntity.status(204).body(deletedTable);
    }
}