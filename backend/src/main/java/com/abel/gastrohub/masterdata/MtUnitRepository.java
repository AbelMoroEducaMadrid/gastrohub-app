package com.abel.gastrohub.masterdata;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MtUnitRepository extends JpaRepository<MtUnit, Integer> {
    Optional<MtUnit> findByName(String name);

    Optional<MtUnit> findBySymbol(String symbol);
}