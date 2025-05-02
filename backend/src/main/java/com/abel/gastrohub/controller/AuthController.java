package com.abel.gastrohub.controller;

import com.abel.gastrohub.dto.UserLoginDTO;
import com.abel.gastrohub.dto.UserRegistrationDTO;
import com.abel.gastrohub.dto.UserResponseDTO;
import com.abel.gastrohub.entity.User;
import com.abel.gastrohub.service.UserService;
import com.abel.gastrohub.util.JwtUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService userService;
    private final JwtUtil jwtUtil;

    public AuthController(UserService userService, JwtUtil jwtUtil) {
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody UserLoginDTO loginRequest) {
        try {
            User user = userService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
            String token = jwtUtil.generateToken(user);
            return ResponseEntity.ok(token);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(401).body("Credenciales inválidas");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDTO> registerUser(@RequestBody UserRegistrationDTO userDTO) {
        User user = new User();
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setPasswordHash(userDTO.getPassword()); // Must be plaintext here
        user.setPhone(userDTO.getPhone());

        User savedUser = userService.createUser(user); // Ensure encoding happens in UserService
        UserResponseDTO responseDTO = new UserResponseDTO(savedUser);
        return ResponseEntity.status(201).body(responseDTO);
    }
}