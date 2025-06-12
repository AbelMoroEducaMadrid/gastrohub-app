package com.abel.gastrohub.product;

import com.abel.gastrohub.ingredient.Ingredient;
import com.abel.gastrohub.masterdata.MtCategory;
import com.abel.gastrohub.product.dto.*;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER','WAITER')")
    public List<ProductListDTO> getAllProducts() {
        return productService.getAllProducts().stream()
                .map(this::toListDTO)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER','WAITER')")
    public ResponseEntity<ProductResponseDTO> getProductById(@PathVariable Integer id) {
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(toResponseDTO(product));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<ProductResponseDTO> createProduct(@Valid @RequestBody ProductCreateDTO productDTO) {
        Product product = toEntity(productDTO);
        Product savedProduct = productService.createProduct(product);
        return ResponseEntity.status(201).body(toResponseDTO(savedProduct));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<ProductResponseDTO> updateProduct(@PathVariable Integer id, @RequestBody ProductCreateDTO productDTO) {
        Product product = toEntity(productDTO);
        Product updatedProduct = productService.updateProduct(id, product);
        return ResponseEntity.ok(toResponseDTO(updatedProduct));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> deleteProduct(@PathVariable Integer id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/ingredients")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public List<ProductResponseDTO.IngredientResponseDTO> getIngredients(@PathVariable Integer id) {
        return productService.getIngredients(id).stream()
                .map(this::toIngredientResponseDTO)
                .collect(Collectors.toList());
    }

    @PostMapping("/{id}/ingredients")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<ProductResponseDTO.IngredientResponseDTO> addIngredient(@PathVariable Integer id,
                                                                                  @RequestBody IngredientAdditionDTO ingredientDTO) {
        RelProductsIngredient rel = toRelEntity(ingredientDTO, id);
        RelProductsIngredient savedRel = productService.addIngredient(id, rel);
        return ResponseEntity.status(201).body(toIngredientResponseDTO(savedRel));
    }

    @DeleteMapping("/{id}/ingredients/{ingredientId}")
    @PreAuthorize("hasAnyRole('ADMIN','OWNER','MANAGER')")
    public ResponseEntity<Void> removeIngredient(@PathVariable Integer id, @PathVariable Integer ingredientId) {
        productService.removeIngredient(id, ingredientId);
        return ResponseEntity.noContent().build();
    }

    private ProductListDTO toListDTO(Product product) {
        ProductListDTO dto = new ProductListDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        return dto;
    }

    private ProductResponseDTO toResponseDTO(Product product) {
        ProductResponseDTO dto = new ProductResponseDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setTotalCost(product.getTotalCost());
        dto.setAvailable(product.getAvailable());
        dto.setIsKitchen(product.getIsKitchen());
        dto.setCategoryId(product.getCategory().getId());
        dto.setIngredients(product.getRelProductsIngredients().stream()
                .map(this::toIngredientResponseDTO)
                .collect(Collectors.toList()));
        return dto;
    }

    private Product toEntity(ProductCreateDTO dto) {
        Product product = new Product();
        product.setName(dto.getName());
        MtCategory category = new MtCategory();
        category.setId(dto.getCategoryId());
        product.setCategory(category);
        product.setAvailable(dto.getAvailable());
        product.setIsKitchen(dto.getIsKitchen());
        if (dto.getIngredients() != null) {
            Set<RelProductsIngredient> rels = dto.getIngredients().stream()
                    .map(ingDTO -> {
                        RelProductsIngredient rel = new RelProductsIngredient();
                        Ingredient ingredient = new Ingredient();
                        ingredient.setId(ingDTO.getIngredientId());
                        rel.setIngredient(ingredient);
                        rel.setQuantity(ingDTO.getQuantity());
                        rel.setProduct(product);
                        return rel;
                    })
                    .collect(Collectors.toSet());
            product.setRelProductsIngredients(rels);
        }
        return product;
    }

    private ProductResponseDTO.IngredientResponseDTO toIngredientResponseDTO(RelProductsIngredient rel) {
        ProductResponseDTO.IngredientResponseDTO dto = new ProductResponseDTO.IngredientResponseDTO();
        dto.setIngredientId(rel.getIngredient().getId());
        dto.setIngredientName(rel.getIngredient().getName());
        dto.setQuantity(rel.getQuantity());
        return dto;
    }

    private RelProductsIngredient toRelEntity(IngredientAdditionDTO dto, Integer productId) {
        RelProductsIngredient rel = new RelProductsIngredient();
        Product product = new Product();
        product.setId(productId);
        rel.setProduct(product);
        Ingredient ingredient = new Ingredient();
        ingredient.setId(dto.getIngredientId());
        rel.setIngredient(ingredient);
        rel.setQuantity(dto.getQuantity());
        return rel;
    }
}