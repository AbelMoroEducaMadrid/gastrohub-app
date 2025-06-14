package com.abel.gastrohub.order;

import com.abel.gastrohub.order.dto.*;
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
        Integer restaurantId = ((CustomUserDetails) userDetails).getRestaurantId();
        if (restaurantId == null) {
            throw new SecurityException("El usuario no está asociado a ningún restaurante");
        }
        return restaurantId;
    }

    public List<OrderResponseDTO> getAllOrdersByRestaurant() {
        Integer restaurantId = getCurrentUserRestaurantId();
        return orderRepository.findByRestaurantId(restaurantId).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }

    public List<OrderResponseDTO> getOrdersByTableId(Integer tableId) {
        Integer restaurantId = getCurrentUserRestaurantId();
        List<Order> orders = orderRepository.findByTableId(tableId);
        orders = orders.stream()
                .filter(order -> order.getRestaurant().getId().equals(restaurantId))
                .toList();
        return orders.stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }

    public List<OrderResponseDTO> getOrdersWithoutTable() {
        Integer restaurantId = getCurrentUserRestaurantId();
        List<Order> orders = orderRepository.findByRestaurantIdAndTableIsNull(restaurantId);
        return orders.stream()
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

    public RelOrdersProduct addItemToOrder(Integer orderId, OrderItemDTO itemDTO) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + orderId));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para modificar esta comanda");
        }

        Product product = productService.getProductById(itemDTO.getProductId());
        RelOrdersProduct item = new RelOrdersProduct();
        item.setOrder(order);
        item.setProduct(product);
        item.setPrice(itemDTO.getPrice());
        item.setNotes(itemDTO.getNotes());

        return relOrdersProductRepository.save(item);
    }

    public RelOrdersProduct updateOrderItem(Integer orderId, Integer itemId, OrderItemDTO itemDTO) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + orderId));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para modificar esta comanda");
        }

        RelOrdersProduct item = relOrdersProductRepository.findById(itemId)
                .orElseThrow(() -> new NoSuchElementException("Ítem no encontrado con ID: " + itemId));
        if (!item.getOrder().getId().equals(orderId)) {
            throw new IllegalArgumentException("El ítem no pertenece a esta comanda");
        }

        if (itemDTO.getPrice() != null) item.setPrice(itemDTO.getPrice());
        if (itemDTO.getNotes() != null) item.setNotes(itemDTO.getNotes());

        return relOrdersProductRepository.save(item);
    }

    public void deleteOrderItem(Integer orderId, Integer itemId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + orderId));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para modificar esta comanda");
        }

        RelOrdersProduct item = relOrdersProductRepository.findById(itemId)
                .orElseThrow(() -> new NoSuchElementException("Ítem no encontrado con ID: " + itemId));
        if (!item.getOrder().getId().equals(orderId)) {
            throw new IllegalArgumentException("El ítem no pertenece a esta comanda");
        }
        if (item.getState() != OrderItemState.pendiente) {
            throw new IllegalStateException("No se puede eliminar un ítem que no está en estado 'pendiente'");
        }

        relOrdersProductRepository.delete(item);
    }

    public RelOrdersProduct changeOrderItemState(Integer orderId, Integer itemId, OrderItemState newState) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NoSuchElementException("Comanda no encontrada con ID: " + orderId));
        if (!order.getRestaurant().getId().equals(getCurrentUserRestaurantId())) {
            throw new SecurityException("No autorizado para modificar esta comanda");
        }

        RelOrdersProduct item = relOrdersProductRepository.findById(itemId)
                .orElseThrow(() -> new NoSuchElementException("Ítem no encontrado con ID: " + itemId));
        if (!item.getOrder().getId().equals(orderId)) {
            throw new IllegalArgumentException("El ítem no pertenece a esta comanda");
        }

        item.setState(newState);
        return relOrdersProductRepository.save(item);
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