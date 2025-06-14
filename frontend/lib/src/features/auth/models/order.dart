class Order {
  final int id;
  final int? tableId;
  final int? tableNumber;
  final String? layout;
  final String? notes;
  final bool urgent;
  final String state;
  final String paymentState;
  final String paymentMethod;
  final List<OrderItem> items;
  final double total;

  Order({
    required this.id,
    this.tableId,
    this.tableNumber,
    this.layout,
    this.notes,
    required this.urgent,
    required this.state,
    required this.paymentState,
    required this.paymentMethod,
    required this.items,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      tableId: json['tableId'] as int?,
      tableNumber: json['tableNumber'] as int?,
      layout: json['layout'] as String?,
      notes: json['notes'] as String?,
      urgent: json['urgent'] as bool,
      state: json['state'] as String,
      paymentState: json['paymentState'] as String,
      paymentMethod: json['paymentMethod'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class OrderItem {
  final int? id;
  final int productId;
  final String productName;
  final double price;
  final String? notes;
  final String? state;
  final int quantity;

  OrderItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.notes,
    this.state,
    this.quantity = 1,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      productId: json['productId'] as int,
      productName: json['product'] as String,
      price: (json['price'] as num).toDouble(),
      notes: json['notes'] as String?,
      state: json['state'] as String?,
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
