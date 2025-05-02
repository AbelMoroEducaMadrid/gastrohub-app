package com.abel.gastrohub.restaurant;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;

    @Autowired
    public RestaurantService(RestaurantRepository restaurantRepository) {
        this.restaurantRepository = restaurantRepository;
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findByDeletedAtIsNull();
    }

    public Restaurant getRestaurantById(Integer id) {
        return restaurantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
    }

    public Restaurant createRestaurant(Restaurant restaurant) {
        if (restaurant.getOwner() == null) {
            throw new IllegalArgumentException("El propietario del restaurante es obligatorio");
        }
        return restaurantRepository.save(restaurant);
    }

    public Restaurant updateRestaurant(Integer id, Restaurant restaurantDetails) {
        Restaurant restaurant = restaurantRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
        restaurant.setName(restaurantDetails.getName());
        restaurant.setAddress(restaurantDetails.getAddress());
        restaurant.setCuisineType(restaurantDetails.getCuisineType());
        if (restaurantDetails.getOwner() != null) {
            restaurant.setOwner(restaurantDetails.getOwner());
        } else {
            throw new IllegalArgumentException("El propietario del restaurante es obligatorio");
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