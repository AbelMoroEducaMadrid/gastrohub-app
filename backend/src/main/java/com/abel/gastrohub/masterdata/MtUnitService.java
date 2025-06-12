package com.abel.gastrohub.masterdata;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class MtUnitService {

    private final MtUnitRepository unitRepository;

    public MtUnitService(MtUnitRepository unitRepository) {
        this.unitRepository = unitRepository;
    }

    // Obtener todas las unidades
    public List<MtUnit> getAllUnits() {
        return unitRepository.findAll();
    }

    // Obtener una unidad por ID
    public MtUnit getUnitById(Integer id) {
        return unitRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Unidad no encontrada con ID: " + id));
    }

    // Obtener una unidad por nombre
    public MtUnit getUnitByName(String name) {
        return unitRepository.findByName(name)
                .orElseThrow(() -> new NoSuchElementException("Unidad no encontrada con nombre: " + name));
    }

    // Obtener una unidad por símbolo
    public MtUnit getUnitBySymbol(String symbol) {
        return unitRepository.findBySymbol(symbol)
                .orElseThrow(() -> new NoSuchElementException("Unidad no encontrada con símbolo: " + symbol));
    }
}