package com.abel.gastrohub.ingredient;

import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.security.CustomUserDetails;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

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
        Ingredient ingredient = ingredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Ingrediente no encontrado con ID: " + id));
        if (!ingredient.getRestaurant().getId().equals(restaurantId)) {
            throw new SecurityException("No autorizado para acceder a este ingrediente");
        }
        return ingredient;
    }

    public Ingredient createIngredient(Ingredient ingredient) {
        Integer restaurantId = getCurrentRestaurantId();
        Restaurant restaurant = new Restaurant();
        restaurant.setId(restaurantId);
        ingredient.setRestaurant(restaurant);
        validateIngredient(ingredient);
        return ingredientRepository.save(ingredient);
    }

    public Ingredient updateIngredient(Integer id, Ingredient ingredientDetails) {
        Ingredient ingredient = getIngredientById(id);
        ingredient.setName(ingredientDetails.getName());
        ingredient.setUnit(ingredientDetails.getUnit());
        ingredient.setStock(ingredientDetails.getStock());
        ingredient.setCostPerUnit(ingredientDetails.getCostPerUnit());
        ingredient.setMinStock(ingredientDetails.getMinStock());
        ingredient.setIsComposite(ingredientDetails.getIsComposite());
        validateIngredient(ingredient);
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
        if (!parent.getUnit().getId().equals(component.getUnit().getId())) {
            throw new IllegalArgumentException("La unidad del componente debe coincidir con la del ingrediente compuesto");
        }
        component.setParentIngredient(parent);
        component.setComponentIngredient(child);
        return relIngredientIngredientRepository.save(component);
    }

    public void deleteComponent(Integer parentId, Integer componentId) {
        Ingredient parent = getIngredientById(parentId);
        RelIngredientIngredientId id = new RelIngredientIngredientId();
        id.setParentIngredientId(parentId);
        id.setComponentIngredientId(componentId);
        RelIngredientIngredient component = relIngredientIngredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Componente no encontrado"));
        relIngredientIngredientRepository.delete(component);
    }

    private void validateIngredient(Ingredient ingredient) {
        if (ingredient.getIsComposite() && !ingredient.getRelIngredientIngredients().isEmpty()) {
            for (RelIngredientIngredient rel : ingredient.getRelIngredientIngredients()) {
                if (!rel.getUnit().getId().equals(ingredient.getUnit().getId())) {
                    throw new IllegalArgumentException("Las unidades de los componentes deben coincidir con la del ingrediente compuesto");
                }
            }
        }
    }

    private Integer getCurrentRestaurantId() {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userDetails.getRestaurantId();
    }
}