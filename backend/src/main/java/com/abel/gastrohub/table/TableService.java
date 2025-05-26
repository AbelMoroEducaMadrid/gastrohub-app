package com.abel.gastrohub.table;

import com.abel.gastrohub.layout.Layout;
import com.abel.gastrohub.layout.LayoutService;
import com.abel.gastrohub.security.CustomUserDetails;
import com.abel.gastrohub.table.dto.TableCreateDTO;
import com.abel.gastrohub.table.dto.TableResponseDTO;
import com.abel.gastrohub.table.dto.TableUpdateDTO;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class TableService {

    private final TableRepository tableRepository;
    private final LayoutService layoutService;

    public TableService(TableRepository tableRepository, LayoutService layoutService) {
        this.tableRepository = tableRepository;
        this.layoutService = layoutService;
    }

    private Integer getCurrentUserRestaurantId() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return ((CustomUserDetails) userDetails).getRestaurantId();
    }

    public List<TableResponseDTO> getAllTablesByLayout(Integer layoutId) {
        return tableRepository.findByLayoutId(layoutId).stream()
                .map(TableResponseDTO::new)
                .collect(Collectors.toList());
    }

    public TableResponseDTO getTableById(Integer id) {
        Table table = tableRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Mesa no encontrada con ID: " + id));
        if (!table.getLayout().getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para acceder a esta mesa");
        }
        return new TableResponseDTO(table);
    }

    public TableResponseDTO createTable(TableCreateDTO tableDTO) {
        Layout layout = layoutService.getLayoutById(tableDTO.getLayoutId());
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para crear mesas en este layout");
        }
        if (tableRepository.findByLayoutIdAndNumber(layout.getId(), tableDTO.getNumber()).isPresent()) {
            throw new IllegalArgumentException("Ya existe una mesa con ese número en el layout");
        }
        Table table = new Table();
        table.setLayout(layout);
        table.setNumber(tableDTO.getNumber());
        table.setCapacity(tableDTO.getCapacity());
        table.setCreatedAt(LocalDateTime.now());
        table.setUpdatedAt(LocalDateTime.now());
        Table savedTable = tableRepository.save(table);
        return new TableResponseDTO(savedTable);
    }

    public TableResponseDTO updateTable(Integer id, TableUpdateDTO tableDTO) {
        Table table = tableRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Mesa no encontrada con ID: " + id));
        if (!table.getLayout().getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para actualizar esta mesa");
        }
        if (tableDTO.getNumber() != null && !tableDTO.getNumber().equals(table.getNumber())) {
            if (tableRepository.findByLayoutIdAndNumber(table.getLayout().getId(), tableDTO.getNumber())
                    .isPresent()) {
                throw new IllegalArgumentException("Ya existe una mesa con ese número en el layout");
            }
            table.setNumber(tableDTO.getNumber());
        }
        if (tableDTO.getCapacity() != null) {
            table.setCapacity(tableDTO.getCapacity());
        }
        if (tableDTO.getState() != null) {
            table.setState(tableDTO.getState());
        }
        table.setUpdatedAt(LocalDateTime.now());
        Table updatedTable = tableRepository.save(table);
        return new TableResponseDTO(updatedTable);
    }

    public void deleteTable(Integer id) {
        Table table = tableRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Mesa no encontrada con ID: " + id));
        if (!table.getLayout().getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para eliminar esta mesa");
        }
        // Validar estado
        if (table.getState() == TableState.ocupada || table.getState() == TableState.reservada) {
            throw new IllegalStateException("No se puede eliminar: la mesa está ocupada o reservada");
        }
        tableRepository.delete(table);
    }
}