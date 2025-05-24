package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.masterdata.MtRole;
import com.abel.gastrohub.paymentPlan.PaymentPlan;
import com.abel.gastrohub.paymentPlan.PaymentPlanService;
import com.abel.gastrohub.restaurant.dto.RestaurantRegistrationDTO;
import com.abel.gastrohub.restaurant.dto.RestaurantResponseDTO;
import com.abel.gastrohub.restaurant.dto.RestaurantUpdateDTO;
import com.abel.gastrohub.security.CustomUserDetails;
import com.abel.gastrohub.user.User;
import com.abel.gastrohub.user.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/restaurants")
public class RestaurantController {

    private final RestaurantService restaurantService;
    private final PaymentPlanService paymentPlanService;
    private final UserService userService;

    public RestaurantController(RestaurantService restaurantService, PaymentPlanService paymentPlanService, UserService userService) {
        this.restaurantService = restaurantService;
        this.paymentPlanService = paymentPlanService;
        this.userService = userService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public List<RestaurantResponseDTO> getAllRestaurants() {
        return restaurantService.getAllRestaurants().stream()
                .map(RestaurantResponseDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM','OWNER')")
    public ResponseEntity<RestaurantResponseDTO> getRestaurantById(@PathVariable Integer id) {
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        return ResponseEntity.ok(new RestaurantResponseDTO(restaurant));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM','USER')")
    public ResponseEntity<RestaurantResponseDTO> createRestaurant(@Valid @RequestBody RestaurantRegistrationDTO restaurantDTO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Integer userId = userDetails.getId();
        User user = userService.getUserById(userId);

        PaymentPlan paymentPlan = paymentPlanService.getPaymentPlanById(restaurantDTO.getPaymentPlanId());
        Restaurant restaurant = new Restaurant();
        restaurant.setName(restaurantDTO.getName());
        restaurant.setAddress(restaurantDTO.getAddress());
        restaurant.setCuisineType(restaurantDTO.getCuisineType());
        restaurant.setDescription(restaurantDTO.getDescription());
        restaurant.setPaymentPlan(paymentPlan);
        restaurant.setPaid(false);
        Restaurant savedRestaurant = restaurantService.createRestaurant(restaurant);

        if (user.getRole().getName().equals("ROLE_USER")) {
            MtRole ownerRole = userService.getRoleByName("ROLE_OWNER");

            User updatedUserDetails = new User();
            updatedUserDetails.setRole(ownerRole);
            updatedUserDetails.setRestaurant(savedRestaurant);

            userService.updateUser(user.getId(), updatedUserDetails);
        }

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
        restaurant.setPaid(false);
        Restaurant updatedRestaurant = restaurantService.updateRestaurant(id, restaurant);
        return ResponseEntity.ok(new RestaurantResponseDTO(updatedRestaurant));
    }
}