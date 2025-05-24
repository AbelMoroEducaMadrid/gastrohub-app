package com.abel.gastrohub.security;

import com.abel.gastrohub.exception.InvalidCredentialsException;
import com.abel.gastrohub.user.User;
import com.abel.gastrohub.user.UserService;
import com.abel.gastrohub.user.dto.UserLoginDTO;
import com.abel.gastrohub.user.dto.UserRegistrationDTO;
import com.abel.gastrohub.user.dto.UserResponseDTO;
import com.abel.gastrohub.util.JwtUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.*;

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
            throw new InvalidCredentialsException("Credenciales inválidas");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDTO> registerUser(@RequestBody UserRegistrationDTO userDTO) {
        User user = new User();
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setPasswordHash(userDTO.getPassword());
        user.setPhone(userDTO.getPhone());

        User savedUser = userService.createUser(user);
        UserResponseDTO responseDTO = new UserResponseDTO(savedUser);
        return ResponseEntity.status(201).body(responseDTO);
    }

    @GetMapping("/oauth2/success")
    public ResponseEntity<String> oauth2Success(OAuth2AuthenticationToken authentication) {
        OAuth2User oauth2User = authentication.getPrincipal();
        String email = oauth2User.getAttribute("email");
        String name = oauth2User.getAttribute("name");

        User user = userService.findByEmail(email);
        if (user == null) {
            user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPasswordHash("OAUTH_USER");
            user = userService.createUser(user);
        }

        String token = jwtUtil.generateToken(user);
        return ResponseEntity.ok(token);
    }
}