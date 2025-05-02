package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.restaurant.dto.RestaurantResponseDTO;
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
    public RestaurantController(RestaurantService restaurantService) {
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
    public ResponseEntity<Restaurant> createRestaurant(@RequestBody Restaurant restaurant) {
        Restaurant savedRestaurant = restaurantService.createRestaurant(restaurant);
        return ResponseEntity.status(201).body(savedRestaurant);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> updateRestaurant(@PathVariable Integer id, @RequestBody Restaurant restaurantDetails) {
        Restaurant updatedRestaurant = restaurantService.updateRestaurant(id, restaurantDetails);
        return ResponseEntity.ok(new RestaurantResponseDTO(updatedRestaurant));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<RestaurantResponseDTO> deleteRestaurant(@PathVariable Integer id) {
        Restaurant deletedRestaurant = restaurantService.deleteRestaurant(id);
        return ResponseEntity.ok(new RestaurantResponseDTO(deletedRestaurant));
    }
}