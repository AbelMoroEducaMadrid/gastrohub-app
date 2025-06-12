package com.abel.gastrohub.product;

import com.abel.gastrohub.ingredient.Ingredient;
import com.abel.gastrohub.ingredient.IngredientRepository;
import com.abel.gastrohub.product.dto.IngredientAdditionDTO;
import com.abel.gastrohub.restaurant.Restaurant;
import com.abel.gastrohub.restaurant.RestaurantRepository;
import com.abel.gastrohub.security.CustomUserDetails;
import jakarta.persistence.EntityManager;
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
    private final RestaurantRepository restaurantRepository;
    private final EntityManager entityManager;

    public ProductService(ProductRepository productRepository,
                          RelProductsIngredientRepository relProductsIngredientRepository,
                          IngredientRepository ingredientRepository,
                          RestaurantRepository restaurantRepository,
                          EntityManager entityManager) {
        this.productRepository = productRepository;
        this.relProductsIngredientRepository = relProductsIngredientRepository;
        this.ingredientRepository = ingredientRepository;
        this.restaurantRepository = restaurantRepository;
        this.entityManager = entityManager;
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
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new NoSuchElementException("Restaurante no encontrado con ID: " + restaurantId));
        product.setRestaurant(restaurant);

        // Guardar el producto sin relaciones primero
        Product savedProduct = productRepository.save(product);

        Set<RelProductsIngredient> rels = product.getRelProductsIngredients();
        if (rels != null && !rels.isEmpty()) {
            for (RelProductsIngredient rel : rels) {
                RelProductsIngredient newRel = new RelProductsIngredient();

                newRel.setProduct(savedProduct);

                Ingredient ingredient = ingredientRepository.findById(rel.getIngredient().getId())
                        .orElseThrow(() -> new NoSuchElementException("Ingrediente no encontrado con ID: " + rel.getIngredient().getId()));
                newRel.setIngredient(ingredient);

                newRel.setQuantity(rel.getQuantity());
                
                relProductsIngredientRepository.save(newRel);
            }

            savedProduct = productRepository.findById(savedProduct.getId()).orElse(savedProduct);
        }

        validateProduct(savedProduct);
        return savedProduct;
    }

    @Transactional
    public Product updateProduct(Integer id, Product productDetails) {
        Product product = getProductById(id);
        product.setName(productDetails.getName());
        product.setCategory(productDetails.getCategory());
        product.setAvailable(productDetails.getAvailable());
        product.setIsKitchen(productDetails.getIsKitchen());
        product.setPrice(productDetails.getPrice());

        if (productDetails.getRelProductsIngredients() != null) {
            product.getRelProductsIngredients().clear();
            for (RelProductsIngredient newRel : productDetails.getRelProductsIngredients()) {
                RelProductsIngredientId relId = new RelProductsIngredientId(product.getId(), newRel.getIngredient().getId());
                newRel.setId(relId);
                newRel.setProduct(product);
                product.getRelProductsIngredients().add(newRel);
            }
        }

        validateProduct(product);
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

        RelProductsIngredientId relId = new RelProductsIngredientId(product.getId(), ingredient.getId());
        if (relProductsIngredientRepository.existsById(relId)) {
            throw new IllegalArgumentException("El ingrediente ya está asociado al producto");
        }

        rel.setProduct(product);
        rel.setIngredient(ingredient);
        rel.setId(relId);

        RelProductsIngredient savedRel = relProductsIngredientRepository.save(rel);

        product.getRelProductsIngredients().add(savedRel);

        productRepository.save(product);

        return savedRel;
    }

    @Transactional
    public void removeIngredient(Integer productId, Integer ingredientId) {
        Product product = getProductById(productId);
        RelProductsIngredientId id = new RelProductsIngredientId(productId, ingredientId);
        RelProductsIngredient rel = relProductsIngredientRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Relación no encontrada"));

        product.getRelProductsIngredients().remove(rel);

        productRepository.save(product);
    }

    @Transactional
    public RelProductsIngredient updateIngredient(Integer productId, Integer ingredientId, IngredientAdditionDTO dto) {
        Product product = getProductById(productId);
        RelProductsIngredientId relId = new RelProductsIngredientId(productId, ingredientId);
        RelProductsIngredient rel = relProductsIngredientRepository.findById(relId)
                .orElseThrow(() -> new NoSuchElementException("Relación no encontrada"));

        rel.setQuantity(dto.getQuantity());

        RelProductsIngredient updatedRel = relProductsIngredientRepository.save(rel);

        productRepository.save(product);

        return updatedRel;
    }

    private void validateProduct(Product product) {
        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El precio no puede ser nulo ni negativo");
        }

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

    private Integer getCurrentRestaurantId() {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userDetails.getRestaurantId();
    }
}