package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.ingredient.dto.IngredientDTO;
import com.abel.gastrohub.ingredient.dto.RelIngredientIngredientDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ingredients")
public class IngredientController {

    private final IngredientService ingredientService;

    public IngredientController(IngredientService ingredientService) {
        this.ingredientService = ingredientService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientDTO> getAllIngredients() {
        return ingredientService.getAllIngredients().stream()
                .map(IngredientDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/non-composite")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientDTO> getNonCompositeIngredients() {
        return ingredientService.getNonCompositeIngredients().stream()
                .map(IngredientDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/composite")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientDTO> getCompositeIngredients() {
        return ingredientService.getCompositeIngredients().stream()
                .map(IngredientDTO::new)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientDTO> getIngredientById(@PathVariable Integer id) {
        Ingredient ingredient = ingredientService.getIngredientById(id);
        return ResponseEntity.ok(new IngredientDTO(ingredient));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientDTO> createIngredient(@RequestBody IngredientDTO ingredientDTO) {
        Ingredient ingredient = ingredientDTO.toEntity();
        Ingredient savedIngredient = ingredientService.createIngredient(ingredient);
        return ResponseEntity.status(201).body(new IngredientDTO(savedIngredient));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientDTO> updateIngredient(@PathVariable Integer id, @RequestBody IngredientDTO ingredientDTO) {
        Ingredient ingredient = ingredientDTO.toEntity();
        Ingredient updatedIngredient = ingredientService.updateIngredient(id, ingredient);
        return ResponseEntity.ok(new IngredientDTO(updatedIngredient));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> deleteIngredient(@PathVariable Integer id) {
        ingredientService.deleteIngredient(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/components")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<RelIngredientIngredientDTO> getComponents(@PathVariable Integer id) {
        return ingredientService.getComponents(id).stream()
                .map(RelIngredientIngredientDTO::new)
                .collect(Collectors.toList());
    }

    @PostMapping("/{id}/components")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<RelIngredientIngredientDTO> addComponent(@PathVariable Integer id,
                                                                   @RequestBody RelIngredientIngredientDTO componentDTO) {
        RelIngredientIngredient component = componentDTO.toEntity();
        RelIngredientIngredient savedComponent = ingredientService.addComponent(id, component);
        return ResponseEntity.status(201).body(new RelIngredientIngredientDTO(savedComponent));
    }

    @DeleteMapping("/{id}/components/{componentId}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> deleteComponent(@PathVariable Integer id, @PathVariable Integer componentId) {
        ingredientService.deleteComponent(id, componentId);
        return ResponseEntity.noContent().build();
    }
}