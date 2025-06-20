package com.abel.gastrohub.security;

import com.abel.gastrohub.user.User;
import com.abel.gastrohub.user.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String idStr) throws UsernameNotFoundException {
        try {
            int id = Integer.parseInt(idStr);
            User user = userRepository.findById(id)
                    .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + idStr));

            Integer restaurantId = user.getRestaurant() != null ? user.getRestaurant().getId() : null;
            return new CustomUserDetails(
                    user.getId(),
                    restaurantId,
                    user.getEmail(),
                    user.getPasswordHash(),
                    Collections.singletonList(new SimpleGrantedAuthority(user.getRole().getName())));
        } catch (NumberFormatException e) {
            throw new UsernameNotFoundException("ID inválido: " + idStr);
        }
    }
}