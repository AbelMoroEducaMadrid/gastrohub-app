package com.abel.gastrohub.masterdata;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<List<MtRole>> getAllRoles() {
        return ResponseEntity.ok(roleService.getAllRoles());
    }

    // Obtener un rol por ID
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<MtRole> getRoleById(@PathVariable Integer id) {
        return ResponseEntity.ok(roleService.getRoleById(id));
    }

    // Obtener un rol por nombre
    @GetMapping("/name/{name}")
    @PreAuthorize("hasAnyRole('ADMIN','SYSTEM')")
    public ResponseEntity<MtRole> getRoleByName(@PathVariable String name) {
        return ResponseEntity.ok(roleService.getRoleByName(name));
    }
}
