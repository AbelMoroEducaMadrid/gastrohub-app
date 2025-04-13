package com.abel.gastrohub.service;

import com.abel.gastrohub.entity.MtRole;
import com.abel.gastrohub.entity.User;
import com.abel.gastrohub.repository.MtRoleRepository;
import com.abel.gastrohub.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final MtRoleRepository roleRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    // Inyección de dependencias mediante constructor
    @Autowired
    public UserService(UserRepository userRepository, MtRoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
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
        MtRole defaultRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("Rol por defecto no encontrado"));
        user.setRole(defaultRole);
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        return userRepository.save(user);
    }

    // Actualizar un usuario existente
    public User updateUser(Integer id, User userDetails) {
        User user = userRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setName(userDetails.getName());
        user.setEmail(userDetails.getEmail());
        user.setPhone(userDetails.getPhone());
        user.setStatus(userDetails.getStatus());
        if (userDetails.getPasswordHash() != null && !userDetails.getPasswordHash().isEmpty()) {
            user.setPasswordHash(passwordEncoder.encode(userDetails.getPasswordHash()));
        }
        return userRepository.save(user);
    }

    // Borrado lógico de un usuario
    public User deleteUser(Integer id) {
        User user = userRepository.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setDeletedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    // Log in de usuario
    public User authenticate(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        User user = userOpt.orElseThrow(() -> new IllegalArgumentException("Credenciales inválidas"));
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new IllegalArgumentException("Credenciales inválidas");
        }
        user.setLastLogin(LocalDateTime.now());
        return userRepository.save(user);
    }

    // Cambio de contraseña
    public void changePassword(Integer id, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}