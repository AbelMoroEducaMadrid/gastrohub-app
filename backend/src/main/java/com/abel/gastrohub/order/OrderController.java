package com.abel.gastrohub.order;

import com.abel.gastrohub.order.dto.*;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<List<OrderResponseDTO>> getAllOrdersForCurrentRestaurant() {
        List<OrderResponseDTO> orders = orderService.getAllOrdersByRestaurant();
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/table/{tableId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<List<OrderResponseDTO>> getOrdersByTableId(@PathVariable Integer tableId) {
        List<OrderResponseDTO> orders = orderService.getOrdersByTableId(tableId);
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/bar")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<List<OrderResponseDTO>> getOrdersWithoutTable() {
        List<OrderResponseDTO> orders = orderService.getOrdersWithoutTable();
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderResponseDTO> getOrderById(@PathVariable Integer id) {
        OrderResponseDTO order = orderService.getOrderById(id);
        return ResponseEntity.ok(order);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderResponseDTO> createOrder(@Valid @RequestBody OrderCreateDTO orderDTO) {
        OrderResponseDTO createdOrder = orderService.createOrder(orderDTO);
        return ResponseEntity.status(201).body(createdOrder);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderResponseDTO> updateOrder(@PathVariable Integer id, @RequestBody OrderUpdateDTO orderDTO) {
        OrderResponseDTO updatedOrder = orderService.updateOrder(id, orderDTO);
        return ResponseEntity.ok(updatedOrder);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<Void> deleteOrder(@PathVariable Integer id) {
        orderService.deleteOrder(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{orderId}/items")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderItemResponseDTO> addItemToOrder(@PathVariable Integer orderId, @Valid @RequestBody OrderItemDTO itemDTO) {
        RelOrdersProduct item = orderService.addItemToOrder(orderId, itemDTO);
        OrderItemResponseDTO responseDTO = new OrderItemResponseDTO(item);
        return ResponseEntity.status(201).body(responseDTO);
    }

    @PutMapping("/{orderId}/items/{itemId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderItemResponseDTO> updateOrderItem(@PathVariable Integer orderId, @PathVariable Integer itemId, @RequestBody OrderItemDTO itemDTO) {
        RelOrdersProduct item = orderService.updateOrderItem(orderId, itemId, itemDTO);
        OrderItemResponseDTO responseDTO = new OrderItemResponseDTO(item);
        return ResponseEntity.ok(responseDTO);
    }

    @DeleteMapping("/{orderId}/items/{itemId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER')")
    public ResponseEntity<Void> deleteOrderItem(@PathVariable Integer orderId, @PathVariable Integer itemId) {
        orderService.deleteOrderItem(orderId, itemId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{orderId}/items/{itemId}/state")
    @PreAuthorize("hasAnyRole('ADMIN', 'OWNER', 'MANAGER', 'WAITER')")
    public ResponseEntity<OrderItemResponseDTO> changeOrderItemState(
            @PathVariable Integer orderId,
            @PathVariable Integer itemId,
            @RequestBody UpdateOrderItemStateDTO stateDTO) {
        RelOrdersProduct item = orderService.changeOrderItemState(orderId, itemId, stateDTO.getNewState());
        OrderItemResponseDTO responseDTO = new OrderItemResponseDTO(item);
        return ResponseEntity.ok(responseDTO);
    }
}