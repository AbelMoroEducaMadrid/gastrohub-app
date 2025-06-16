package com.abel.gastrohub.restaurant;

import com.abel.gastrohub.layout.Layout;
import com.abel.gastrohub.layout.LayoutRepository;
import com.abel.gastrohub.table.Table;
import com.abel.gastrohub.table.TableRepository;
import com.abel.gastrohub.table.TableState;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;
    private final LayoutRepository layoutRepository;
    private final TableRepository tableRepository;

    public RestaurantService(RestaurantRepository restaurantRepository,
                             LayoutRepository layoutRepository,
                             TableRepository tableRepository) {
        this.restaurantRepository = restaurantRepository;
        this.layoutRepository = layoutRepository;
        this.tableRepository = tableRepository;
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    public Restaurant getRestaurantById(Integer id) {
        return restaurantRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + id));
    }

    @Transactional
    public Restaurant createRestaurant(Restaurant restaurant) {
        Restaurant savedRestaurant = restaurantRepository.save(restaurant);

        Layout layout = new Layout();
        layout.setRestaurant(savedRestaurant);
        layout.setName("Layout por defecto");
        layout.setCreatedAt(LocalDateTime.now());
        layout.setUpdatedAt(LocalDateTime.now());
        Layout savedLayout = layoutRepository.save(layout);

        Table table = new Table();
        table.setLayout(savedLayout);
        table.setNumber(1);
        table.setCapacity(4);
        table.setCreatedAt(LocalDateTime.now());
        table.setUpdatedAt(LocalDateTime.now());
        table.setState(TableState.disponible);
        tableRepository.save(table);

        return savedRestaurant;
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
        restaurantRepository.delete(restaurant);
    }

    public Restaurant regenerateInvitationCode(Integer id) {
        Restaurant restaurant = getRestaurantById(id);
        restaurant.setInvitationCode(generateInvitationCode());
        restaurant.setInvitationExpiresAt(LocalDateTime.now().plusHours(12));
        return restaurantRepository.save(restaurant);
    }

    public String getValidInvitationCode(Integer restaurantId) {
        Restaurant restaurant = getRestaurantById(restaurantId);
        if (restaurant.getInvitationExpiresAt() == null || restaurant.getInvitationExpiresAt().isBefore(LocalDateTime.now())) {
            restaurant = regenerateInvitationCode(restaurantId);
        }
        return restaurant.getInvitationCode();
    }

    private String generateInvitationCode() {
        return UUID.randomUUID().toString().substring(0, 8);
    }
}