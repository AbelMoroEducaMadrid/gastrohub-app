package com.abel.gastrohub.user;

import com.abel.gastrohub.exception.PhoneAlreadyInUseException;
import com.abel.gastrohub.masterdata.MtRole;
import com.abel.gastrohub.masterdata.MtRoleRepository;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.restaurant.RestaurantRepository;
import com.abel.gastrohub.user.dto.UserProfileUpdateDTO;
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
    private final RestaurantRepository restaurantRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, MtRoleRepository roleRepository,
                       RestaurantRepository restaurantRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.restaurantRepository = restaurantRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Integer id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
    }

    public User createUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new IllegalArgumentException("El email " + user.getEmail() + " ya está registrado");
        }
        if (user.getPhone() != null && userRepository.findByPhone(user.getPhone()).isPresent()) {
            throw new PhoneAlreadyInUseException("El número de teléfono " + user.getPhone() + " ya está en uso");
        }
        MtRole defaultRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("Rol por defecto no encontrado"));
        user.setRole(defaultRole);
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        return userRepository.save(user);
    }

    public User updateUser(Integer id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        if (userDetails.getName() != null) {
            user.setName(userDetails.getName());
        }
        if (userDetails.getEmail() != null) {
            user.setEmail(userDetails.getEmail());
        }
        if (userDetails.getPhone() != null && !userDetails.getPhone().equals(user.getPhone())) {
            if (userRepository.findByPhone(userDetails.getPhone()).isPresent()) {
                throw new PhoneAlreadyInUseException(
                        "El número de teléfono " + userDetails.getPhone() + " ya está en uso");
            }
            user.setPhone(userDetails.getPhone());
        }
        if (userDetails.getPasswordHash() != null && !userDetails.getPasswordHash().isEmpty()) {
            user.setPasswordHash(passwordEncoder.encode(userDetails.getPasswordHash()));
        }
        if (userDetails.getRole() != null) {
            user.setRole(userDetails.getRole());
        }
        if (userDetails.getRestaurant() != null) {
            user.setRestaurant(userDetails.getRestaurant());
        }
        return userRepository.save(user);
    }

    public void deleteUser(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        userRepository.delete(user);
    }

    public User authenticate(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        User user = userOpt.orElseThrow(() -> new IllegalArgumentException("Credenciales inválidas"));
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new IllegalArgumentException("Credenciales inválidas");
        }
        user.setLastLogin(LocalDateTime.now());
        return userRepository.save(user);
    }

    public void changePassword(Integer id, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Usuario no encontrado con ID: " + id));
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    public User joinRestaurant(Integer userId, String invitationCode) {
        User user = getUserById(userId);
        Restaurant restaurant = restaurantRepository.findByInvitationCode(invitationCode)
                .orElseThrow(() -> new NoSuchElementException("Código de invitación no válido"));
        if (restaurant.getInvitationExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("El código de invitación ha expirado");
        }
        user.setRestaurant(restaurant);
        return userRepository.save(user);
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    public MtRole getRoleByName(String name) {
        return roleRepository.findByName(name)
                .orElseThrow(() -> new RuntimeException("Rol no encontrado: " + name));
    }

    public void leaveRestaurant(Integer userId) {
        User user = getUserById(userId);
        if (user.getRestaurant() != null) {
            user.setRestaurant(null);
            MtRole userRole = getRoleByName("ROLE_USER");
            user.setRole(userRole);
            userRepository.save(user);
        }
    }

    public void kickUser(Integer userIdToKick, Integer ownerId) {
        User owner = getUserById(ownerId);
        if (!owner.getRole().getName().equals("ROLE_OWNER")) {
            throw new IllegalStateException("Solo el propietario puede expulsar usuarios");
        }
        User userToKick = getUserById(userIdToKick);
        if (userToKick.getRestaurant() == null || owner.getRestaurant() == null ||
                !userToKick.getRestaurant().getId().equals(owner.getRestaurant().getId())) {
            throw new IllegalStateException("El usuario no pertenece al restaurante del propietario");
        }
        if (userToKick.getId().equals(owner.getId())) {
            throw new IllegalStateException("El propietario no puede expulsarse a sí mismo");
        }
        userToKick.setRestaurant(null);
        MtRole userRole = getRoleByName("ROLE_USER");
        userToKick.setRole(userRole);
        userRepository.save(userToKick);
    }

    public User updateProfile(Integer userId, UserProfileUpdateDTO dto) {
        User user = getUserById(userId);
        if (dto.getEmail() != null && !dto.getEmail().equals(user.getEmail())) {
            if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
                throw new IllegalArgumentException("El email ya está en uso");
            }
            user.setEmail(dto.getEmail());
        }
        if (dto.getPhone() != null && !dto.getPhone().equals(user.getPhone())) {
            if (userRepository.findByPhone(dto.getPhone()).isPresent()) {
                throw new PhoneAlreadyInUseException("El número de teléfono ya está en uso");
            }
            user.setPhone(dto.getPhone());
        }
        if (dto.getName() != null) {
            user.setName(dto.getName());
        }
        return userRepository.save(user);
    }
}