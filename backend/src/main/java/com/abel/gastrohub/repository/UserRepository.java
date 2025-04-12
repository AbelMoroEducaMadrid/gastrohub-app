package com.abel.gastrohub.repository;

import com.abel.gastrohub.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}