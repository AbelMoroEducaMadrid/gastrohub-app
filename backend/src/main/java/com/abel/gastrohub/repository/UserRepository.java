package com.abel.gastrohub.repository;

import com.abel.gastrohub.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    List<User> findByDeletedAtIsNull();

    Optional<User> findByIdAndDeletedAtIsNull(Integer id);

    Optional<User> findByEmail(String email);
}