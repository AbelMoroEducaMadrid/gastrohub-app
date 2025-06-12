package com.abel.gastrohub.security;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

public class CustomUserDetails implements UserDetails {
    @Getter
    private int id;
    @Getter
    private Integer restaurantId;
    private String passwordHash;
    private Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(Integer id, Integer restaurantId, String email, String passwordHash,
                             Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.passwordHash = passwordHash;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return passwordHash;
    }

    @Override
    public String getUsername() {
        return String.valueOf(id);
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
}