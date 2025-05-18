package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.paymentPlan.PaymentPlan;
import com.abel.gastrohub.paymentPlan.PaymentPlanService;
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
    private final PaymentPlanService paymentPlanService;

    @Autowired
    public RestaurantController(RestaurantService restaurantService, PaymentPlanService paymentPlanService, UserRepository userRepository) {
        this.restaurantService = restaurantService;
        this.paymentPlanService = paymentPlanService;
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
        PaymentPlan paymentPlan = paymentPlanService.getPaymentPlanById(restaurantDTO.getPaymentPlanId());
        Restaurant restaurant = new Restaurant();
        restaurant.setName(restaurantDTO.getName());
        restaurant.setAddress(restaurantDTO.getAddress());
        restaurant.setCuisineType(restaurantDTO.getCuisineType());
        restaurant.setDescription(restaurantDTO.getDescription());
        restaurant.setPaymentPlan(paymentPlan);
        restaurant.setPaid(false); // Inicialmente no pagado
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

    @PostMapping("/{id}/regenerate-invitation")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM', 'OWNER')")
    public ResponseEntity<String> regenerateInvitationCode(@PathVariable Integer id) {
        Restaurant updatedRestaurant = restaurantService.regenerateInvitationCode(id);
        return ResponseEntity.ok(updatedRestaurant.getInvitationCode());
    }

    @PutMapping("/{id}/change-plan")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM', 'OWNER')")
    public ResponseEntity<RestaurantResponseDTO> changePaymentPlan(@PathVariable Integer id, @RequestParam Integer newPlanId) {
        PaymentPlan newPlan = paymentPlanService.getPaymentPlanById(newPlanId);
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        restaurant.setPaymentPlan(newPlan);
        restaurant.setPaid(false); // Requiere nuevo pago tras cambio
        Restaurant updatedRestaurant = restaurantService.updateRestaurant(id, restaurant);
        return ResponseEntity.ok(new RestaurantResponseDTO(updatedRestaurant));
    }
}