package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.restaurant.dto.RestaurantRegistrationDTO;
import com.abel.gastrohub.restaurant.dto.RestaurantResponseDTO;
import com.abel.gastrohub.restaurant.dto.RestaurantUpdateDTO;
import com.abel.gastrohub.user.UserRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    private final RestaurantService restaurantService;

    @Autowired
    public RestaurantController(RestaurantService restaurantService, UserRepository userRepository) {
        this.restaurantService = restaurantService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public List<RestaurantResponseDTO> getAllRestaurants() {
        return restaurantService.getAllRestaurants().stream()
                .map(RestaurantResponseDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> getRestaurantById(@PathVariable Integer id) {
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        return ResponseEntity.ok(new RestaurantResponseDTO(restaurant));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> createRestaurant(@Valid @RequestBody RestaurantRegistrationDTO restaurantDTO) {
        Restaurant restaurant = new Restaurant();
        restaurant.setName(restaurantDTO.getName());
        restaurant.setAddress(restaurantDTO.getAddress());
        restaurant.setCuisineType(restaurantDTO.getCuisineType());
        restaurant.setDescription(restaurantDTO.getDescription());
        Restaurant savedRestaurant = restaurantService.createRestaurant(restaurant);
        return ResponseEntity.status(201).body(new RestaurantResponseDTO(savedRestaurant));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> updateRestaurant(@PathVariable Integer id, @Valid @RequestBody RestaurantUpdateDTO restaurantDTO) {
        Restaurant restaurant = new Restaurant();
        restaurant.setName(restaurantDTO.getName());
        restaurant.setAddress(restaurantDTO.getAddress());
        restaurant.setCuisineType(restaurantDTO.getCuisineType());
        restaurant.setDescription(restaurantDTO.getDescription());
        Restaurant updatedRestaurant = restaurantService.updateRestaurant(id, restaurant);
        return ResponseEntity.ok(new RestaurantResponseDTO(updatedRestaurant));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> deleteRestaurant(@PathVariable Integer id) {
        Restaurant deletedRestaurant = restaurantService.deleteRestaurant(id);
        return ResponseEntity.ok(new RestaurantResponseDTO(deletedRestaurant));
    }
}