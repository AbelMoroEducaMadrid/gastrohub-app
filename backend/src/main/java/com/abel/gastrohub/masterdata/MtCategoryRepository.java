package com.abel.gastrohub.masterdata;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MtCategoryRepository extends JpaRepository<MtCategory, Integer> {
    Optional<MtCategory> findByName(String name);
}