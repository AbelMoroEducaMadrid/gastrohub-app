package com.abel.gastrohub.repository;

import com.abel.gastrohub.entity.MtRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MtRoleRepository extends JpaRepository<MtRole, Integer> {
    Optional<MtRole> findByName(String name);
}