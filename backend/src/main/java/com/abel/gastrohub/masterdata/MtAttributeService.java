package com.abel.gastrohub.masterdata;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class MtAttributeService {

    private final MtAttributeRepository attributeRepository;

    public MtAttributeService(MtAttributeRepository attributeRepository) {
        this.attributeRepository = attributeRepository;
    }

    // Obtener todos los atributos
    public List<MtAttribute> getAllAttributes() {
        return attributeRepository.findAll();
    }

    // Obtener un atributo por ID
    public MtAttribute getAttributeById(Integer id) {
        return attributeRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Atributo no encontrado con ID: " + id));
    }

    // Obtener un atributo por nombre
    public MtAttribute getAttributeByName(String name) {
        return attributeRepository.findByName(name)
                .orElseThrow(() -> new NoSuchElementException("Atributo no encontrado con nombre: " + name));
    }
}