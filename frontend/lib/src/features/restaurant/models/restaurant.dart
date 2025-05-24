class Restaurant {
  final int id;
  final String name;
  final String address;
  final String cuisineType;
  final String description;
  final int paymentPlanId;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.cuisineType,
    required this.description,
    required this.paymentPlanId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      cuisineType: json['cuisineType'] as String,
      description: json['description'] as String,
      paymentPlanId: json['paymentPlanId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'cuisineType': cuisineType,
      'description': description,
      'paymentPlanId': paymentPlanId,
    };
  }
}
