package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.masterdata.MtUnit;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.security.CustomUserDetails;
import jakarta.persistence.EntityManager;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;

@Service
public class IngredientService {

    private EntityManager entityManager;
    private final IngredientRepository ingredientRepository;
    private final RelIngredientIngredientRepository relIngredientIngredientRepository;

    public IngredientService(EntityManager entityManager,
                             IngredientRepository ingredientRepository,
                             RelIngredientIngredientRepository relIngredientIngredientRepository) {
        this.entityManager = entityManager;
        this.ingredientRepository = ingredientRepository;
        this.relIngredientIngredientRepository = relIngredientIngredientRepository;
    }

    public List<Ingredient> getAllIngredients() {
        Integer restaurantId = getCurrentRestaurantId();
        return ingredientRepository.findByRestaurantId(restaurantId);
    }

    public List<Ingredient> getNonCompositeIngredients() {
        Integer restaurantId = getCurrentRestaurantId();
        return ingredientRepository.findByRestaurantIdAndIsComposite(restaurantId, false);
    }

    public List<Ingredient> getCompositeIngredients() {
        Integer restaurantId = getCurrentRestaurantId();
        return ingredientRepository.findByRestaurantIdAndIsComposite(restaurantId, true);
    }

    public Ingredient getIngredientById(Integer id) {
        Integer restaurantId = getCurrentRestaurantId();
        return ingredientRepository.findByIdAndRestaurantId(id, restaurantId)
                .orElseThrow(() -> new NoSuchElementException("Ingrediente no encontrado con ID: " + id + " para el restaurante: " + restaurantId));
    }

    public Ingredient createIngredient(Ingredient ingredient) {
        Integer restaurantId = getCurrentRestaurantId();
        Restaurant restaurant = new Restaurant();
        restaurant.setId(restaurantId);
        ingredient.setRestaurant(restaurant);

        Set<RelIngredientIngredient> components = ingredient.getRelIngredientIngredients();
        ingredient.setRelIngredientIngredients(null);
        Ingredient savedIngredient = ingredientRepository.save(ingredient);
        System.out.println("Después de guardar el ingrediente, ID: " + savedIngredient.getId());

        if (ingredient.getIsComposite() && components != null && !components.isEmpty()) {
            for (RelIngredientIngredient rel : components) {
                rel.setParentIngredient(savedIngredient);
                RelIngredientIngredientId id = new RelIngredientIngredientId(savedIngredient.getId(), rel.getComponentIngredient().getId());
                rel.setId(id);
                relIngredientIngredientRepository.save(rel);
            }

            savedIngredient.setRelIngredientIngredients(components);
        }

        validateIngredient(savedIngredient);
        calculateCompositeCost(savedIngredient);
        return savedIngredient;
    }

    public Ingredient updateIngredient(Integer id, Ingredient ingredientDetails) {
        Ingredient ingredient = getIngredientById(id);

        ingredient.setName(ingredientDetails.getName());
        ingredient.setUnit(ingredientDetails.getUnit());
        ingredient.setStock(ingredientDetails.getStock());
        ingredient.setCostPerUnit(ingredientDetails.getCostPerUnit());
        ingredient.setMinStock(ingredientDetails.getMinStock());
        ingredient.setIsComposite(ingredientDetails.getIsComposite());

        if (ingredient.getIsComposite()) {
            Set<RelIngredientIngredient> newComponents = ingredientDetails.getRelIngredientIngredients();
            Set<RelIngredientIngredient> currentComponents = ingredient.getRelIngredientIngredients();

            if (newComponents == null || newComponents.isEmpty()) {
                currentComponents.clear();
            } else {
                currentComponents.removeIf(rel -> !newComponents.stream()
                        .anyMatch(newRel -> newRel.getComponentIngredient().getId().equals(rel.getComponentIngredient().getId())));

                for (RelIngredientIngredient newRel : newComponents) {
                    RelIngredientIngredient existingRel = currentComponents.stream()
                            .filter(rel -> rel.getComponentIngredient().getId().equals(newRel.getComponentIngredient().getId()))
                            .findFirst()
                            .orElse(null);

                    if (existingRel != null) {
                        existingRel.setQuantity(newRel.getQuantity());
                        existingRel.setUnit(newRel.getUnit());
                    } else {
                        newRel.setParentIngredient(ingredient);
                        RelIngredientIngredientId relId = new RelIngredientIngredientId(ingredient.getId(), newRel.getComponentIngredient().getId());
                        newRel.setId(relId);
                        currentComponents.add(newRel);
                    }
                }
            }
        } else {
            ingredient.getRelIngredientIngredients().clear();
        }

        validateIngredient(ingredient);
        calculateCompositeCost(ingredient);

        return ingredientRepository.save(ingredient);
    }

    public void deleteIngredient(Integer id) {
        Ingredient ingredient = getIngredientById(id);
        if (ingredientRepository.existsByIdAndParentIngredientsNotEmpty(id)) {
            throw new IllegalStateException("No se puede eliminar: el ingrediente es componente de otros");
        }
        ingredientRepository.delete(ingredient);
    }

    public List<RelIngredientIngredient> getComponents(Integer parentId) {
        Ingredient parent = getIngredientById(parentId);
        if (!parent.getIsComposite()) {
            throw new IllegalStateException("El ingrediente no es compuesto");
        }
        return relIngredientIngredientRepository.findByParentIngredientId(parentId);
    }

    public RelIngredientIngredient addComponent(Integer parentId, RelIngredientIngredient component) {
        Ingredient parent = getIngredientById(parentId);
        if (!parent.getIsComposite()) {
            throw new IllegalStateException("El ingrediente no es compuesto");
        }
        Ingredient child = getIngredientById(component.getComponentIngredient().getId());
        if (child.getIsComposite()) {
            throw new IllegalStateException("Un ingrediente compuesto no puede ser componente de otro");
        }
        if (!child.getUnit().getId().equals(component.getUnit().getId())) {
            throw new IllegalArgumentException("La unidad del componente debe coincidir con la registrada: " + child.getUnit().getId());
        }

        RelIngredientIngredientId relId = new RelIngredientIngredientId(parent.getId(), child.getId());
        if (relIngredientIngredientRepository.existsById(relId)) {
            throw new IllegalArgumentException("El componente ya está asociado al ingrediente compuesto");
        }

        component.setParentIngredient(parent);
        component.setComponentIngredient(child);
        component.setId(relId);

        RelIngredientIngredient savedComponent = relIngredientIngredientRepository.save(component);

        parent.getRelIngredientIngredients().add(savedComponent);
        calculateCompositeCost(parent);
        ingredientRepository.save(parent);

        return savedComponent;
    }

    @Transactional
    public void deleteComponent(Integer parentId, Integer componentId) {
        Ingredient parent = getIngredientById(parentId);
        RelIngredientIngredientId id = new RelIngredientIngredientId(parentId, componentId);
        RelIngredientIngredient component = relIngredientIngredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Componente no encontrado"));

        parent.getRelIngredientIngredients().remove(component);

        entityManager.flush();

        calculateCompositeCost(parent);
        ingredientRepository.save(parent);
    }

    private void validateIngredient(Ingredient ingredient) {
        if (ingredient.getIsComposite() && ingredient.getRelIngredientIngredients().isEmpty()) {
            throw new IllegalArgumentException("Un ingrediente compuesto debe tener al menos un componente");
        }
        if (ingredient.getIsComposite()) {
            for (RelIngredientIngredient rel : ingredient.getRelIngredientIngredients()) {
                Ingredient component = rel.getComponentIngredient();
                MtUnit componentRegisteredUnit = component.getUnit();
                MtUnit componentRelationUnit = rel.getUnit();
                if (!componentRelationUnit.getId().equals(componentRegisteredUnit.getId())) {
                    throw new IllegalArgumentException(
                            "La unidad del componente '" + component.getName() + "' en la relación (" +
                                    componentRelationUnit.getId() + ") no coincide con su unidad registrada (" +
                                    componentRegisteredUnit.getId() + ")"
                    );
                }
            }
        }
    }

    private void calculateCompositeCost(Ingredient ingredient) {
        if (ingredient.getIsComposite()) {
            BigDecimal totalCost = BigDecimal.ZERO;
            for (RelIngredientIngredient rel : ingredient.getRelIngredientIngredients()) {
                Ingredient component = rel.getComponentIngredient();
                if (component.getCostPerUnit() == null) {
                    throw new IllegalStateException("El componente '" + component.getName() + "' no tiene un costPerUnit asignado");
                }
                BigDecimal componentCost = component.getCostPerUnit().multiply(rel.getQuantity());
                totalCost = totalCost.add(componentCost);
            }
            ingredient.setCostPerUnit(totalCost);
        }
    }

    private Integer getCurrentRestaurantId() {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userDetails.getRestaurantId();
    }
}