package com.abel.gastrohub.user;

import com.abel.gastrohub.user.dto.UserResponseDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    List<User> findByDeletedAtIsNull();

    Optional<User> findByIdAndDeletedAtIsNull(Integer id);

    Optional<User> findByEmail(String email);

    @Query("SELECT new com.abel.gastrohub.user.dto.UserResponseDTO(u.id, u.name, u.email, u.phone, u.role.name, r.id, r.name, u.lastLogin) " +
            "FROM User u LEFT JOIN u.restaurant r WHERE u.id = :id AND u.deletedAt IS NULL")
    Optional<UserResponseDTO> findUserResponseDTOById(@Param("id") Integer id);
}