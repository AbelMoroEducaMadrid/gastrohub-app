package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.masterdata.MtUnit;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.security.CustomUserDetails;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;

@Service
public class IngredientService {

    private final IngredientRepository ingredientRepository;
    private final RelIngredientIngredientRepository relIngredientIngredientRepository;

    public IngredientService(IngredientRepository ingredientRepository,
                             RelIngredientIngredientRepository relIngredientIngredientRepository) {
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
        if (ingredient.getIsComposite() && ingredientDetails.getCostPerUnit() != null && ingredientDetails.getCostPerUnit().compareTo(BigDecimal.ZERO) != 0) {
            throw new IllegalArgumentException("El costPerUnit no debe proporcionarse para ingredientes compuestos");
        }
        ingredient.setName(ingredientDetails.getName());
        ingredient.setName(ingredientDetails.getName());
        ingredient.setUnit(ingredientDetails.getUnit());
        ingredient.setStock(ingredientDetails.getStock());
        ingredient.setCostPerUnit(ingredientDetails.getCostPerUnit());
        ingredient.setMinStock(ingredientDetails.getMinStock());
        ingredient.setIsComposite(ingredientDetails.getIsComposite());
        if (ingredientDetails.getRelIngredientIngredients() != null) {
            ingredient.getRelIngredientIngredients().clear();
            ingredient.getRelIngredientIngredients().addAll(ingredientDetails.getRelIngredientIngredients());
            for (RelIngredientIngredient rel : ingredient.getRelIngredientIngredients()) {
                rel.setParentIngredient(ingredient);
            }
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
        component.setParentIngredient(parent);
        component.setComponentIngredient(child);
        RelIngredientIngredient savedComponent = relIngredientIngredientRepository.save(component);
        calculateCompositeCost(parent);
        ingredientRepository.save(parent);
        return savedComponent;
    }

    public void deleteComponent(Integer parentId, Integer componentId) {
        Ingredient parent = getIngredientById(parentId);
        RelIngredientIngredientId id = new RelIngredientIngredientId(parentId, componentId);
        RelIngredientIngredient component = relIngredientIngredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Componente no encontrado"));
        relIngredientIngredientRepository.delete(component);
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