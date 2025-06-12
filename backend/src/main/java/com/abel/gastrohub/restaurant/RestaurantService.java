package com.abel.gastrohub.restaurant;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;

    public RestaurantService(RestaurantRepository restaurantRepository) {
        this.restaurantRepository = restaurantRepository;
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    public Restaurant getRestaurantById(Integer id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
    }

    public Restaurant createRestaurant(Restaurant restaurant) {
        return restaurantRepository.save(restaurant);
    }

    public Restaurant updateRestaurant(Integer id, Restaurant restaurantDetails) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
        restaurant.setName(restaurantDetails.getName());
        restaurant.setAddress(restaurantDetails.getAddress());
        restaurant.setCuisineType(restaurantDetails.getCuisineType());
        restaurant.setDescription(restaurantDetails.getDescription());
        if (restaurantDetails.getPaymentPlan() != null) {
            restaurant.setPaymentPlan(restaurantDetails.getPaymentPlan());
        }
        if (restaurantDetails.getPaid() != null) {
            restaurant.setPaid(restaurantDetails.getPaid());
        }
        return restaurantRepository.save(restaurant);
    }

    public void deleteRestaurant(Integer id) {
        Restaurant restaurant = restaurantRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
//        if (orderRepository.existsByRestaurantIdAndStateNot(id, OrderState.SERVIDA, OrderState.CANCELADA)) {
//            throw new IllegalStateException("No se puede eliminar: hay comandas activas");
//        }
//        if (reservationRepository.existsByRestaurantIdAndState(id, ReservationState.PENDIENTE)) {
//            throw new IllegalStateException("No se puede eliminar: hay reservas pendientes");
//        }
// TODO Terminar de implementar esta parte
        restaurantRepository.delete(restaurant);
    }

    public Restaurant regenerateInvitationCode(Integer id) {
        Restaurant restaurant = getRestaurantById(id);
        restaurant.setInvitationCode(generateInvitationCode());
        restaurant.setInvitationExpiresAt(LocalDateTime.now().plusHours(12));
        return restaurantRepository.save(restaurant);
    }

    private String generateInvitationCode() {
        return UUID.randomUUID().toString().substring(0, 8);
    }
}