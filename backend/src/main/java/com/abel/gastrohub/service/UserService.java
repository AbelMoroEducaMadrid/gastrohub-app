package com.abel.gastrohub.service;

import com.abel.gastrohub.entity.User;
import com.abel.gastrohub.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    // Inyección de dependencias mediante constructor
    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Obtener todos los usuarios no eliminados
    public List<User> getAllUsers() {
        return userRepository.findByDeletedAtIsNull();
    }

    // Obtener un usuario por ID (solo si no está eliminado)
    public User getUserById(Integer id) {
        return userRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
    }

    // Crear un nuevo usuario
    public User createUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new IllegalArgumentException("El email " + user.getEmail() + " ya está registrado");
        }
        return userRepository.save(user);
    }

    // Actualizar un usuario existente
    public User updateUser(Integer id, User userDetails) {
        User user = userRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setName(userDetails.getName());
        user.setEmail(userDetails.getEmail());
        user.setPasswordHash(userDetails.getPasswordHash());
        user.setRole(userDetails.getRole());
        user.setPhone(userDetails.getPhone());
        user.setRestaurant(userDetails.getRestaurant());
        user.setStatus(userDetails.getStatus());
        return userRepository.save(user);
    }

    // Borrado lógico de un usuario
    public void deleteUser(Integer id) {
        User user = userRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setDeletedAt(Instant.now());
        userRepository.save(user);
    }

    // Log in de usuario
    public User login(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        User user = userOpt.orElseThrow(() -> new IllegalArgumentException("Credenciales inválidas"));
        if (!password.equals(user.getPasswordHash())) {
            throw new IllegalArgumentException("Credenciales inválidas");
        }
        user.setLastLogin(Instant.now());
        return userRepository.save(user);
    }
}