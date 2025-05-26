package com.abel.gastrohub.table;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TableRepository extends JpaRepository<Table, Integer> {

    List<Table> findByLayoutId(Integer layoutId);

    Optional<Table> findByLayoutIdAndNumber(Integer layoutId, Integer number);
}