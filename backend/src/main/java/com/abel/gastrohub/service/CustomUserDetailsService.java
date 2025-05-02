package com.abel.gastrohub.service;

import com.abel.gastrohub.util.CustomUserDetails;
import com.abel.gastrohub.entity.User;
import com.abel.gastrohub.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Autowired
    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));
        boolean enabled = user.getDeletedAt() == null; // Enable only if not logically deleted
        return new CustomUserDetails(
                user.getId(),
                user.getEmail(),
                user.getPasswordHash(),
                Collections.singletonList(new SimpleGrantedAuthority(user.getRole().getName())),
                enabled
        );
    }
}
