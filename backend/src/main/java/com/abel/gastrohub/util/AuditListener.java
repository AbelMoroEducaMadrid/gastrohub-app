package com.abel.gastrohub.util;

import com.abel.gastrohub.entity.IAuditable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;

import java.time.LocalDateTime;

@Component
public class AuditListener {

    @PrePersist
    public void onPrePersist(IAuditable auditable) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            auditable.setCreatedBy(userDetails.getId());
        } else {
            auditable.setCreatedBy(1); // Default system user ID
        }
        auditable.setCreatedAt(LocalDateTime.now());
    }

    @PreUpdate
    public void onPreUpdate(IAuditable auditable) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
            auditable.setUpdatedBy(userDetails.getId());
        } else {
            auditable.setUpdatedBy(1); // Default system user ID
        }
        auditable.setUpdatedAt(LocalDateTime.now());
    }
}
