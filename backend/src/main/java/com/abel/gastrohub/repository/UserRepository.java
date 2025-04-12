package com.abel.gastrohub.repository;

import com.abel.gastrohub.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    // Devuelve todos los usuarios con deleted_at nulo
    List<User> findByDeletedAtIsNull();

    // Devuelve un usuario por ID con deleted_at nulo
    Optional<User> findByIdAndDeletedAtIsNull(Integer id);

    // Busca un usuario por su email
    Optional<Object> findByEmail(String email);
}