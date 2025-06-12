package com.abel.gastrohub.product;

import com.abel.gastrohub.ingredient.Ingredient;
import com.abel.gastrohub.ingredient.IngredientRepository;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.security.CustomUserDetails;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ProductService {

    private final ProductRepository productRepository;
    private final RelProductsIngredientRepository relProductsIngredientRepository;
    private final IngredientRepository ingredientRepository;

    public ProductService(ProductRepository productRepository,
                          RelProductsIngredientRepository relProductsIngredientRepository,
                          IngredientRepository ingredientRepository) {
        this.productRepository = productRepository;
        this.relProductsIngredientRepository = relProductsIngredientRepository;
        this.ingredientRepository = ingredientRepository;
    }

    public List<Product> getAllProducts() {
        Integer restaurantId = getCurrentRestaurantId();
        return productRepository.findByRestaurantId(restaurantId);
    }

    public Product getProductById(Integer id) {
        Integer restaurantId = getCurrentRestaurantId();
        return productRepository.findByIdAndRestaurantId(id, restaurantId)
                .orElseThrow(() -> new NoSuchElementException("Producto no encontrado con ID: " + id + " para el restaurante: " + restaurantId));
    }

    @Transactional
    public Product createProduct(Product product) {
        Integer restaurantId = getCurrentRestaurantId();
        Restaurant restaurant = new Restaurant();
        restaurant.setId(restaurantId);
        product.setRestaurant(restaurant);
        validateProduct(product);
        calculateTotalCost(product);
        return productRepository.save(product);
    }

    @Transactional
    public Product updateProduct(Integer id, Product productDetails) {
        Product product = getProductById(id);
        product.setName(productDetails.getName());
        product.setCategory(productDetails.getCategory());
        product.setAvailable(productDetails.getAvailable());
        product.setIsKitchen(productDetails.getIsKitchen());
        if (productDetails.getRelProductsIngredients() != null) {
            product.getRelProductsIngredients().clear();
            product.getRelProductsIngredients().addAll(productDetails.getRelProductsIngredients());
            for (RelProductsIngredient rel : product.getRelProductsIngredients()) {
                rel.setProduct(product);
            }
        }
        validateProduct(product);
        calculateTotalCost(product);
        return productRepository.save(product);
    }

    @Transactional
    public void deleteProduct(Integer id) {
        Product product = getProductById(id);
        productRepository.delete(product);
    }

    public List<RelProductsIngredient> getIngredients(Integer productId) {        
        return relProductsIngredientRepository.findByProductId(productId);
    }

    @Transactional
    public RelProductsIngredient addIngredient(Integer productId, RelProductsIngredient rel) {
        Product product = getProductById(productId);
        Ingredient ingredient = ingredientRepository.findById(rel.getIngredient().getId())
                .orElseThrow(() -> new NoSuchElementException("Ingrediente no encontrado"));
        if (!ingredient.getRestaurant().getId().equals(product.getRestaurant().getId())) {
            throw new IllegalArgumentException("El ingrediente no pertenece al mismo restaurante que el producto");
        }
        rel.setProduct(product);
        rel.setIngredient(ingredient);
        RelProductsIngredient savedRel = relProductsIngredientRepository.save(rel);
        calculateTotalCost(product);
        productRepository.save(product);
        return savedRel;
    }

    @Transactional
    public void removeIngredient(Integer productId, Integer ingredientId) {
        Product product = getProductById(productId);
        RelProductsIngredientId id = new RelProductsIngredientId();
        id.setProductId(productId);
        id.setIngredientId(ingredientId);
        RelProductsIngredient rel = relProductsIngredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Relación no encontrada"));
        relProductsIngredientRepository.delete(rel);
        calculateTotalCost(product);
        productRepository.save(product);
    }

    private void validateProduct(Product product) {
        Set<Integer> restaurantIds = product.getRelProductsIngredients().stream()
                .map(rel -> rel.getIngredient().getRestaurant().getId())
                .collect(Collectors.toSet());
        if (restaurantIds.size() > 1) {
            throw new IllegalArgumentException("Todos los ingredientes deben pertenecer al mismo restaurante");
        }
        if (!restaurantIds.isEmpty() && !restaurantIds.iterator().next().equals(product.getRestaurant().getId())) {
            throw new IllegalArgumentException("Los ingredientes no pertenecen al restaurante del producto");
        }
    }

    private void calculateTotalCost(Product product) {
        BigDecimal totalCost = BigDecimal.ZERO;
        for (RelProductsIngredient rel : product.getRelProductsIngredients()) {
            Ingredient ingredient = rel.getIngredient();
            BigDecimal ingredientCost = ingredient.getCostPerUnit().multiply(rel.getQuantity());
            totalCost = totalCost.add(ingredientCost);
        }
        product.setTotalCost(totalCost);
    }

    private Integer getCurrentRestaurantId() {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userDetails.getRestaurantId();
    }
}