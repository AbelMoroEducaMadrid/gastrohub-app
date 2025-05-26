package com.abel.gastrohub.masterdata;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MtAttributeRepository extends JpaRepository<MtAttribute, Integer> {
    Optional<MtAttribute> findByName(String name);
}