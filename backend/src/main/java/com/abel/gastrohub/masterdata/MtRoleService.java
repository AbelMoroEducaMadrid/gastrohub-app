package com.abel.gastrohub.masterdata;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class MtRoleService {

    private final MtRoleRepository roleRepository;

    @Autowired
    public MtRoleService(MtRoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    // Obtener todos los roles
    public List<MtRole> getAllRoles() {
        return roleRepository.findAll();
    }

    // Obtener un rol por ID
    public MtRole getRoleById(Integer id) {
        return roleRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Rol no encontrado con ID: " + id));
    }

    // Obtener un rol por nombre
    public MtRole getRoleByName(String name) {
        return roleRepository.findByName(name)
                .orElseThrow(() -> new NoSuchElementException("Rol no encontrado con nombre: " + name));
    }
}