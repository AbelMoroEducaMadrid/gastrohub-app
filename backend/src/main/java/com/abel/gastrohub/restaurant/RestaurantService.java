package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.user.User;
import com.abel.gastrohub.user.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;
    private final UserRepository userRepository;

    @Autowired
    public RestaurantService(RestaurantRepository restaurantRepository, UserRepository userRepository) {
        this.restaurantRepository = restaurantRepository;
        this.userRepository = userRepository;
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findByDeletedAtIsNull();
    }

    public Restaurant getRestaurantById(Integer id) {
        return restaurantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
    }

    public Restaurant createRestaurant(Restaurant restaurant) {
        // Validar que el propietario exista
        User owner = userRepository.findByIdAndDeletedAtIsNull(restaurant.getOwner().getId())
                .orElseThrow(() -> new IllegalArgumentException("Propietario no encontrado con ID: " + restaurant.getOwner().getId()));
        restaurant.setOwner(owner);
        return restaurantRepository.save(restaurant);
    }

    public Restaurant updateRestaurant(Integer id, Restaurant restaurantDetails) {
        Restaurant restaurant = restaurantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
        restaurant.setName(restaurantDetails.getName());
        restaurant.setAddress(restaurantDetails.getAddress());
        restaurant.setCuisineType(restaurantDetails.getCuisineType());
        // Actualizar propietario si se proporciona
        if (restaurantDetails.getOwner() != null) {
            User owner = userRepository.findByIdAndDeletedAtIsNull(restaurantDetails.getOwner().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Propietario no encontrado con ID: " + restaurantDetails.getOwner().getId()));
            restaurant.setOwner(owner);
        }
        return restaurantRepository.save(restaurant);
    }

    public Restaurant deleteRestaurant(Integer id) {
        Restaurant restaurant = restaurantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
        restaurant.setDeletedAt(LocalDateTime.now());
        return restaurantRepository.save(restaurant);
    }
}