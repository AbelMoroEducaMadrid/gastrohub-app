package com.abel.gastrohub.entity;

import java.time.LocalDateTime;

public interface IAuditable {
    void setCreatedBy(Integer createdBy);
    void setUpdatedBy(Integer updatedBy);
    void setCreatedAt(LocalDateTime createdAt);
    void setUpdatedAt(LocalDateTime updatedAt);
    void setDeletedAt(LocalDateTime deletedAt);
}
