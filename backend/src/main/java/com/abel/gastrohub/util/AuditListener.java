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
        if (authentication != null && authentication.isAuthenticated()) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            auditable.setCreatedBy(userDetails.getId());
            auditable.setCreatedAt(LocalDateTime.now());
        }
    }

    @PreUpdate
    public void onPreUpdate(IAuditable auditable) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            auditable.setUpdatedBy(userDetails.getId());
            auditable.setUpdatedAt(LocalDateTime.now());
        }
    }
}
