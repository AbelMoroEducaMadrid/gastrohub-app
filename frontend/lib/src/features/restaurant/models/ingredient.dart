class Ingredient {
  final int id;
  final String name;
  final int unitId;
  final double stock;
  final double costPerUnit;
  final double minStock;
  final bool isComposite;
  final List<Component>? components;

  Ingredient({
    required this.id,
    required this.name,
    required this.unitId,
    required this.stock,
    required this.costPerUnit,
    required this.minStock,
    required this.isComposite,
    this.components,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as int,
      name: json['name'] as String,
      unitId: json['unitId'] as int,
      stock: (json['stock'] as num).toDouble(),
      costPerUnit: (json['costPerUnit'] as num).toDouble(),
      minStock: (json['minStock'] as num).toDouble(),
      isComposite: json['isComposite'] as bool,
      components: json['components'] != null
          ? (json['components'] as List)
              .map((component) => Component.fromJson(component))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unitId': unitId,
      'stock': stock,
      'costPerUnit': costPerUnit,
      'minStock': minStock,
      'isComposite': isComposite,
      'components': components?.map((c) => c.toJson()).toList(),
    };
  }
}

class Component {
  final int componentIngredientId;
  final String componentName;
  final double quantity;
  final int unitId;

  Component({
    required this.componentIngredientId,
    required this.componentName,
    required this.quantity,
    required this.unitId,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      componentIngredientId: json['componentIngredientId'] as int,
      componentName: json['componentName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitId: json['unitId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'componentIngredientId': componentIngredientId,
      'quantity': quantity,
      'unitId': unitId,
    };
  }
}