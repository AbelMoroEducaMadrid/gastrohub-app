class Product {
  final int id;
  final String name;
  final double price;
  final bool available;
  final bool isKitchen;
  final int categoryId;
  final List<ProductIngredient>? ingredients;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
    required this.isKitchen,
    required this.categoryId,
    this.ingredients,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      available: json['available'] as bool,
      isKitchen: json['isKitchen'] as bool,
      categoryId: json['categoryId'] as int,
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
              .map((ingredient) => ProductIngredient.fromJson(ingredient))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'available': available,
      'isKitchen': isKitchen,
      'ingredients': ingredients?.map((i) => i.toJson()).toList(),
    };
  }
}

class ProductIngredient {
  final int ingredientId;
  final String ingredientName;
  final double quantity;

  ProductIngredient({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
  });

  factory ProductIngredient.fromJson(Map<String, dynamic> json) {
    return ProductIngredient(
      ingredientId: json['ingredientId'] as int,
      ingredientName: json['ingredientName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'quantity': quantity,
    };
  }
}
