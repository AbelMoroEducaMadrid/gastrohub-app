package com.abel.gastrohub.service;

import com.abel.gastrohub.entity.MtRole;
import com.abel.gastrohub.repository.MtRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

@Service
public class MtRoleService {

    private final MtRoleRepository roleRepository;

    @Autowired
    public MtRoleService(MtRoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

    // Obtener todos los roles no eliminados
    public List<MtRole> getAllRoles() {
        return roleRepository.findAll().stream()
                .filter(role -> role.getDeletedAt() == null)
                .collect(Collectors.toList());
    }

    // Obtener un rol por ID
    public MtRole getRoleById(Integer id) {
        MtRole role = roleRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Rol no encontrado con ID: " + id));
        if (role.getDeletedAt() != null) {
            throw new NoSuchElementException("Rol no encontrado con ID: " + id);
        }
        return role;
    }

    // Obtener un rol por nombre
    public MtRole getRoleByName(String name) {
        MtRole role = roleRepository.findByName(name)
                .orElseThrow(() -> new NoSuchElementException("Rol no encontrado con nombre: " + name));
        if (role.getDeletedAt() != null) {
            throw new NoSuchElementException("Rol no encontrado con nombre: " + name);
        }
        return role;
    }

    // Crear un nuevo rol
    public MtRole createRole(MtRole role) {
        if (roleRepository.findByName(role.getName()).isPresent()) {
            throw new IllegalArgumentException("El nombre del rol " + role.getName() + " ya existe");
        }
        return roleRepository.save(role);
    }

    // Actualizar un rol
    public MtRole updateRole(Integer id, MtRole roleDetails) {
        MtRole role = getRoleById(id);
        role.setName(roleDetails.getName());
        role.setDescription(roleDetails.getDescription());
        role.setUpdatedAt(LocalDateTime.now());
        return roleRepository.save(role);
    }

    // Borrado lógico de un rol
    public void deleteRole(Integer id) {
        MtRole role = getRoleById(id);
        role.setDeletedAt(LocalDateTime.now());
        roleRepository.save(role);
    }
}