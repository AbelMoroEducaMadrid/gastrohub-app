package com.abel.gastrohub.user;

import com.abel.gastrohub.security.CustomUserDetails;
import com.abel.gastrohub.user.dto.UserChangePasswordDTO;
import com.abel.gastrohub.user.dto.UserJoinRestaurantDTO;
import com.abel.gastrohub.user.dto.UserJoinRestaurantResponseDTO;
import com.abel.gastrohub.user.dto.UserResponseDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public List<UserResponseDTO> getAllUsers() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("Usuario: " + auth.getName() + ", Roles: " + auth.getAuthorities());
        return userService.getAllUsers().stream()
                .map(UserResponseDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<UserResponseDTO> getUserById(@PathVariable Integer id) {
        User user = userService.getUserById(id);
        return ResponseEntity.ok(new UserResponseDTO(user));
    }

    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UserResponseDTO> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Integer userId = userDetails.getId();
        User user = userService.getUserById(userId);
        return ResponseEntity.ok(new UserResponseDTO(user));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User savedUser = userService.createUser(user);
        return ResponseEntity.status(201).body(savedUser);
    }

    @PostMapping("/{id}/change-password")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<Void> changePassword(@PathVariable Integer id, @RequestBody UserChangePasswordDTO changePasswordDTO) {
        userService.changePassword(id, changePasswordDTO.getNewPassword());
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<UserResponseDTO> updateUser(@PathVariable Integer id, @RequestBody User userDetails) {
        User updatedUser = userService.updateUser(id, userDetails);
        return ResponseEntity.ok(new UserResponseDTO(updatedUser));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<UserResponseDTO> deleteUser(@PathVariable Integer id) {
        User deletedUser = userService.deleteUser(id);
        return ResponseEntity.ok(new UserResponseDTO(deletedUser));
    }

    @PostMapping("/join-restaurant")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM','USER')")
    public ResponseEntity<UserJoinRestaurantResponseDTO> joinRestaurant(@RequestBody UserJoinRestaurantDTO joinDTO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Integer userId = userDetails.getId();
        User user = userService.joinRestaurant(userId, joinDTO.getInvitationCode());
        return ResponseEntity.ok(new UserJoinRestaurantResponseDTO(user));
    }
}