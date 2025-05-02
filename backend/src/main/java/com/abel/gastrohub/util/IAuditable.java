package com.abel.gastrohub.util;

import java.time.LocalDateTime;

public interface IAuditable {
    void setCreatedBy(Integer createdBy);
    void setUpdatedBy(Integer updatedBy);
    void setCreatedAt(LocalDateTime createdAt);
    void setUpdatedAt(LocalDateTime updatedAt);
    void setDeletedAt(LocalDateTime deletedAt);
}
