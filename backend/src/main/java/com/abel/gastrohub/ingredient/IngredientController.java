package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.ingredient.dto.ComponentAdditionDTO;
import com.abel.gastrohub.ingredient.dto.IngredientCreateDTO;
import com.abel.gastrohub.ingredient.dto.IngredientResponseDTO;
import com.abel.gastrohub.masterdata.MtAttribute;
import com.abel.gastrohub.masterdata.MtAttributeService;
import com.abel.gastrohub.masterdata.MtUnit;
import com.abel.gastrohub.masterdata.MtUnitRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ingredients")
public class IngredientController {

    private final IngredientService ingredientService;
    private final MtUnitRepository mtUnitRepository;
    private final IngredientRepository ingredientRepository;
    private final MtAttributeService mtAttributeService;

    public IngredientController(IngredientService ingredientService,
                                MtUnitRepository mtUnitRepository,
                                IngredientRepository ingredientRepository,
                                MtAttributeService mtAttributeService) {
        this.ingredientService = ingredientService;
        this.mtUnitRepository = mtUnitRepository;
        this.ingredientRepository = ingredientRepository;
        this.mtAttributeService = mtAttributeService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientResponseDTO> getAllIngredients() {
        return ingredientService.getAllIngredients().stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    @GetMapping("/non-composite")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientResponseDTO> getNonCompositeIngredients() {
        return ingredientService.getNonCompositeIngredients().stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    @GetMapping("/composite")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientResponseDTO> getCompositeIngredients() {
        return ingredientService.getCompositeIngredients().stream()
                .map(this::toResponseDTO)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientResponseDTO> getIngredientById(@PathVariable Integer id) {
        Ingredient ingredient = ingredientService.getIngredientById(id);
        return ResponseEntity.ok(toResponseDTO(ingredient));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientResponseDTO> createIngredient(@Valid @RequestBody IngredientCreateDTO ingredientDTO) {
        Ingredient ingredient = toEntity(ingredientDTO);
        Ingredient savedIngredient = ingredientService.createIngredient(ingredient);
        return ResponseEntity.status(201).body(toResponseDTO(savedIngredient));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientResponseDTO> updateIngredient(@PathVariable Integer id, @RequestBody IngredientCreateDTO ingredientDTO) {
        Ingredient ingredient = toEntity(ingredientDTO);
        Ingredient updatedIngredient = ingredientService.updateIngredient(id, ingredient);
        return ResponseEntity.ok(toResponseDTO(updatedIngredient));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> deleteIngredient(@PathVariable Integer id) {
        ingredientService.deleteIngredient(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/components")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<IngredientResponseDTO.ComponentResponseDTO> getComponents(@PathVariable Integer id) {
        return ingredientService.getComponents(id).stream()
                .map(this::toComponentResponseDTO)
                .collect(Collectors.toList());
    }

    @PostMapping("/{id}/components")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<IngredientResponseDTO.ComponentResponseDTO> addComponent(@PathVariable Integer id,
                                                                                   @RequestBody ComponentAdditionDTO componentDTO) {
        RelIngredientIngredient component = toRelEntity(componentDTO, id);
        RelIngredientIngredient savedComponent = ingredientService.addComponent(id, component);
        return ResponseEntity.status(201).body(toComponentResponseDTO(savedComponent));
    }

    @DeleteMapping("/{id}/components/{componentId}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> deleteComponent(@PathVariable Integer id, @PathVariable Integer componentId) {
        ingredientService.deleteComponent(id, componentId);
        return ResponseEntity.noContent().build();
    }

    private IngredientResponseDTO toResponseDTO(Ingredient ingredient) {
        IngredientResponseDTO dto = new IngredientResponseDTO();
        dto.setId(ingredient.getId());
        dto.setName(ingredient.getName());
        dto.setUnitId(ingredient.getUnit().getId());
        dto.setStock(ingredient.getStock());
        dto.setCostPerUnit(ingredient.getCostPerUnit());
        dto.setMinStock(ingredient.getMinStock());
        dto.setIsComposite(ingredient.getIsComposite());

        Set<String> attributeNames = ingredient.getAttributes().stream()
                .map(MtAttribute::getName).collect(Collectors.toSet());

        if (ingredient.getIsComposite()) {
            dto.setComponents(ingredient.getRelIngredientIngredients().stream()
                    .map(this::toComponentResponseDTO)
                    .collect(Collectors.toList()));

            for (RelIngredientIngredient rel : ingredient.getRelIngredientIngredients()) {
                attributeNames.addAll(rel.getComponentIngredient().getAttributes().stream()
                        .map(MtAttribute::getName)
                        .collect(Collectors.toSet()));
            }
        }

        dto.setAttributes(attributeNames.stream().sorted().collect(Collectors.toList()));
        return dto;
    }

    private Ingredient toEntity(IngredientCreateDTO dto) {
        Ingredient ingredient = new Ingredient();
        ingredient.setName(dto.getName());

        MtUnit unit = mtUnitRepository.findById(dto.getUnitId())
                .orElseThrow(() -> new NoSuchElementException("Unidad no encontrada con ID: " + dto.getUnitId()));
        ingredient.setUnit(unit);

        ingredient.setStock(dto.getStock());
        ingredient.setCostPerUnit(dto.getCostPerUnit());
        ingredient.setMinStock(dto.getMinStock());
        ingredient.setIsComposite(dto.getIsComposite());

        if (dto.getIsComposite() && dto.getComponents() != null) {
            Set<RelIngredientIngredient> components = dto.getComponents().stream()
                    .map(componentDTO -> {
                        RelIngredientIngredient rel = new RelIngredientIngredient();

                        Ingredient componentIngredient = ingredientRepository.findById(componentDTO.getComponentIngredientId())
                                .orElseThrow(() -> new NoSuchElementException("Ingrediente componente no encontrado con ID: " + componentDTO.getComponentIngredientId()));
                        rel.setComponentIngredient(componentIngredient);

                        rel.setQuantity(componentDTO.getQuantity());

                        MtUnit componentUnit = mtUnitRepository.findById(componentDTO.getUnitId())
                                .orElseThrow(() -> new NoSuchElementException("Unidad no encontrada con ID: " + componentDTO.getUnitId()));
                        rel.setUnit(componentUnit);

                        rel.setParentIngredient(ingredient);

                        return rel;
                    })
                    .collect(Collectors.toSet());
            ingredient.setRelIngredientIngredients(components);
        }

        if (dto.getAttributes() != null && !dto.getAttributes().isEmpty()) {
            Set<MtAttribute> attributes = dto.getAttributes().stream()
                    .map(mtAttributeService::getAttributeByName)
                    .collect(Collectors.toSet());
            ingredient.setAttributes(attributes);
        }

        return ingredient;
    }

    private IngredientResponseDTO.ComponentResponseDTO toComponentResponseDTO(RelIngredientIngredient rel) {
        IngredientResponseDTO.ComponentResponseDTO dto = new IngredientResponseDTO.ComponentResponseDTO();
        dto.setComponentIngredientId(rel.getComponentIngredient().getId());
        dto.setComponentName(rel.getComponentIngredient().getName());
        dto.setQuantity(rel.getQuantity());
        dto.setUnitId(rel.getUnit().getId());
        return dto;
    }

    private RelIngredientIngredient toRelEntity(ComponentAdditionDTO dto, Integer parentId) {
        RelIngredientIngredient rel = new RelIngredientIngredient();
        Ingredient parent = new Ingredient();
        parent.setId(parentId);
        rel.setParentIngredient(parent);
        Ingredient component = new Ingredient();
        component.setId(dto.getComponentIngredientId());
        rel.setComponentIngredient(component);
        rel.setQuantity(dto.getQuantity());
        MtUnit unit = new MtUnit();
        unit.setId(dto.getUnitId());
        rel.setUnit(unit);
        return rel;
    }
}