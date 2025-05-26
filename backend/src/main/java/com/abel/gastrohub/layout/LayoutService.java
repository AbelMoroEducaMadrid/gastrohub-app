package com.abel.gastrohub.layout;

import com.abel.gastrohub.layout.dto.LayoutCreateDTO;
import com.abel.gastrohub.layout.dto.LayoutUpdateDTO;
import com.abel.gastrohub.restaurant.RestaurantRepository;
import com.abel.gastrohub.security.CustomUserDetails;
import com.abel.gastrohub.table.Table;
import com.abel.gastrohub.table.TableRepository;
import com.abel.gastrohub.table.TableState;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class LayoutService {

    private final LayoutRepository layoutRepository;
    private final RestaurantRepository restaurantRepository;
    private final TableRepository tableRepository;

    public LayoutService(LayoutRepository layoutRepository, RestaurantRepository restaurantRepository, TableRepository tableRepository) {
        this.layoutRepository = layoutRepository;
        this.restaurantRepository = restaurantRepository;
        this.tableRepository = tableRepository;
    }

    private Integer getCurrentUserRestaurantId() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Integer restaurantId = ((CustomUserDetails) userDetails).getRestaurantId();
        if (restaurantId == null) {
            throw new SecurityException("El usuario no está asociado a ningún restaurante");
        }
        return restaurantId;
    }

    public List<Layout> getAllLayoutsByRestaurant() {
        Integer restaurantId = getCurrentUserRestaurantId();
        return layoutRepository.findByRestaurantId(restaurantId);
    }

    public Layout getLayoutById(Integer id) {
        Layout layout = layoutRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para acceder a este layout");
        }
        return layout;
    }

    public Layout createLayout(LayoutCreateDTO layoutDTO) {
        Integer restaurantId = getCurrentUserRestaurantId();
        if (layoutRepository.findByRestaurantIdAndName(restaurantId, layoutDTO.getName()).isPresent()) {
            throw new IllegalArgumentException("Ya existe un layout con ese nombre en el restaurante");
        }
        Layout layout = new Layout();
        layout.setRestaurant(restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado")));
        layout.setName(layoutDTO.getName());
        return layoutRepository.save(layout);
    }

    public Layout updateLayout(Integer id, LayoutUpdateDTO layoutDTO) {
        Layout layout = layoutRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para actualizar este layout");
        }
        if (layoutDTO.getName() != null && !layoutDTO.getName().equals(layout.getName())) {
            if (layoutRepository.findByRestaurantIdAndName(layout.getRestaurant().getId(), layoutDTO.getName()).isPresent()) {
                throw new IllegalArgumentException("Ya existe un layout con ese nombre en el restaurante");
            }
            layout.setName(layoutDTO.getName());
        }
        layout.setUpdatedAt(LocalDateTime.now());
        return layoutRepository.save(layout);
    }

    public void deleteLayout(Integer id) {
        Layout layout = layoutRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para eliminar este layout");
        }

        List<Table> tables = tableRepository.findByLayoutId(layout.getId());
        boolean hasActiveTables = tables.stream()
                .anyMatch(table -> table.getState() == TableState.ocupada || table.getState() == TableState.reservada);
        if (hasActiveTables) {
            throw new IllegalStateException("No se puede eliminar el layout: contiene mesas ocupadas o reservadas");
        }

        layoutRepository.delete(layout);
    }
}