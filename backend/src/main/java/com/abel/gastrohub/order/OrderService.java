package com.abel.gastrohub.order;

import com.abel.gastrohub.order.dto.OrderCreateDTO;
import com.abel.gastrohub.order.dto.OrderItemResponseDTO;
import com.abel.gastrohub.order.dto.OrderResponseDTO;
import com.abel.gastrohub.order.dto.OrderUpdateDTO;
import com.abel.gastrohub.product.Product;
import com.abel.gastrohub.product.ProductService;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.restaurant.RestaurantService;
import com.abel.gastrohub.security.CustomUserDetails;
import com.abel.gastrohub.table.Table;
import com.abel.gastrohub.table.TableService;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final RelOrdersProductRepository relOrdersProductRepository;
    private final RestaurantService restaurantService;
    private final TableService tableService;
    private final ProductService productService;

    public OrderService(OrderRepository orderRepository, RelOrdersProductRepository relOrdersProductRepository,
                        RestaurantService restaurantService, TableService tableService, ProductService productService) {
        this.orderRepository = orderRepository;
        this.relOrdersProductRepository = relOrdersProductRepository;
        this.restaurantService = restaurantService;
        this.tableService = tableService;
        this.productService = productService;
    }

    private Integer getCurrentUserRestaurantId() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return ((CustomUserDetails) userDetails).getRestaurantId();
    }

    public List<OrderResponseDTO> getAllOrdersByRestaurant(Integer restaurantId) {
        if (!restaurantId.equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para acceder a las comandas de este restaurante");
        }
        return orderRepository.findByRestaurantId(restaurantId).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }

    public OrderResponseDTO getOrderById(Integer id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + id));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para acceder a esta comanda");
        }
        return mapToResponseDTO(order);
    }

    public OrderResponseDTO createOrder(OrderCreateDTO orderDTO) {
        Restaurant restaurant = restaurantService.getRestaurantById(orderDTO.getRestaurantId());
        if (!restaurant.getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para crear comandas en este restaurante");
        }

        Order order = new Order();
        order.setRestaurant(restaurant);
        if (orderDTO.getTableId() != null) {
            Table table = tableService.getTableById(orderDTO.getTableId());
            if (!table.getLayout().getRestaurant().getId().equals(restaurant.getId())) {
                throw new IllegalArgumentException("La mesa no pertenece al restaurante");
            }
            order.setTable(table);
        }
        order.setNotes(orderDTO.getNotes());
        order.setUrgent(orderDTO.getUrgent());

        Order savedOrder = orderRepository.save(order);

        List<RelOrdersProduct> items = orderDTO.getItems().stream().map(itemDTO -> {
            Product product = productService.getProductById(itemDTO.getProductId());
            RelOrdersProduct item = new RelOrdersProduct();
            item.setOrder(savedOrder);
            item.setProduct(product);
            item.setPrice(itemDTO.getPrice());
            item.setNotes(itemDTO.getNotes());
            return item;
        }).collect(Collectors.toList());

        relOrdersProductRepository.saveAll(items);

        return mapToResponseDTO(savedOrder);
    }

    public OrderResponseDTO updateOrder(Integer id, OrderUpdateDTO orderDTO) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + id));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para actualizar esta comanda");
        }

        if (orderDTO.getNotes() != null) order.setNotes(orderDTO.getNotes());
        if (orderDTO.getUrgent() != null) order.setUrgent(orderDTO.getUrgent());
        if (orderDTO.getState() != null) order.setState(orderDTO.getState());
        if (orderDTO.getPaymentState() != null) order.setPaymentState(orderDTO.getPaymentState());
        if (orderDTO.getPaymentMethod() != null) order.setPaymentMethod(orderDTO.getPaymentMethod());

        Order updatedOrder = orderRepository.save(order);
        return mapToResponseDTO(updatedOrder);
    }

    public void deleteOrder(Integer id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + id));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para eliminar esta comanda");
        }
        if (order.getState() != OrderState.cancelada && order.getPaymentState() != PaymentState.completado) {
            throw new IllegalStateException("No se puede eliminar: la comanda no está cancelada ni pagada");
        }
        orderRepository.delete(order);
    }

    private OrderResponseDTO mapToResponseDTO(Order order) {
        OrderResponseDTO responseDTO = new OrderResponseDTO(order);
        List<OrderItemResponseDTO> items = relOrdersProductRepository.findByOrderId(order.getId()).stream()
                .map(OrderItemResponseDTO::new)
                .collect(Collectors.toList());
        responseDTO.setItems(items);
        return responseDTO;
    }
}