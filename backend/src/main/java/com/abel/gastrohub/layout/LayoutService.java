package com.abel.gastrohub.layout;

import com.abel.gastrohub.layout.dto.LayoutCreateDTO;
import com.abel.gastrohub.layout.dto.LayoutUpdateDTO;
import com.abel.gastrohub.restaurant.RestaurantRepository;
import com.abel.gastrohub.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    public LayoutService(LayoutRepository layoutRepository, RestaurantRepository restaurantRepository) {
        this.layoutRepository = layoutRepository;
        this.restaurantRepository = restaurantRepository;
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
        return layoutRepository.findByRestaurantIdAndDeletedAtIsNull(restaurantId);
    }

    public Layout getLayoutById(Integer id) {
        Layout layout = layoutRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para acceder a este layout");
        }
        return layout;
    }

    public Layout createLayout(LayoutCreateDTO layoutDTO) {
        Integer restaurantId = getCurrentUserRestaurantId();
        if (layoutRepository.findByRestaurantIdAndNameAndDeletedAtIsNull(restaurantId, layoutDTO.getName()).isPresent()) {
            throw new IllegalArgumentException("Ya existe un layout con ese nombre en el restaurante");
        }
        Layout layout = new Layout();
        layout.setRestaurant(restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado")));
        layout.setName(layoutDTO.getName());
        layout.setCreatedAt(LocalDateTime.now());
        layout.setUpdatedAt(LocalDateTime.now());
        return layoutRepository.save(layout);
    }

    public Layout updateLayout(Integer id, LayoutUpdateDTO layoutDTO) {
        Layout layout = layoutRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para actualizar este layout");
        }
        if (layoutDTO.getName() != null && !layoutDTO.getName().equals(layout.getName())) {
            if (layoutRepository.findByRestaurantIdAndNameAndDeletedAtIsNull(layout.getRestaurant().getId(), layoutDTO.getName()).isPresent()) {
                throw new IllegalArgumentException("Ya existe un layout con ese nombre en el restaurante");
            }
            layout.setName(layoutDTO.getName());
        }
        layout.setUpdatedAt(LocalDateTime.now());
        return layoutRepository.save(layout);
    }

    public Layout deleteLayout(Integer id) {
        Layout layout = layoutRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Layout no encontrado con ID: " + id));
        if (!layout.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para eliminar este layout");
        }
        layout.setDeletedAt(LocalDateTime.now());
        return layoutRepository.save(layout);
    }
}