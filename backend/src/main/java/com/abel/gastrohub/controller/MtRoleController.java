package com.abel.gastrohub.controller;

import com.abel.gastrohub.entity.MtRole;
import com.abel.gastrohub.service.MtRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class MtRoleController {

    private final MtRoleService roleService;

    @Autowired
    public MtRoleController(MtRoleService roleService) {
        this.roleService = roleService;
    }

    // Obtener todos los roles
    @GetMapping
    public ResponseEntity<List<MtRole>> getAllRoles() {
        List<MtRole> roles = roleService.getAllRoles();
        return ResponseEntity.ok(roles);
    }

    // Obtener un rol por ID
    @GetMapping("/{id}")
    public ResponseEntity<MtRole> getRoleById(@PathVariable Integer id) {
        MtRole role = roleService.getRoleById(id);
        return ResponseEntity.ok(role);
    }

    // Crear un nuevo rol
    @PostMapping
    public ResponseEntity<MtRole> createRole(@RequestBody MtRole role) {
        MtRole savedRole = roleService.createRole(role);
        return ResponseEntity.status(201).body(savedRole);
    }

    // Actualizar un rol
    @PutMapping("/{id}")
    public ResponseEntity<MtRole> updateRole(@PathVariable Integer id, @RequestBody MtRole roleDetails) {
        MtRole updatedRole = roleService.updateRole(id, roleDetails);
        return ResponseEntity.ok(updatedRole);
    }

    // Eliminar un rol (borrado lógico)
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRole(@PathVariable Integer id) {
        roleService.deleteRole(id);
        return ResponseEntity.noContent().build();
    }
}