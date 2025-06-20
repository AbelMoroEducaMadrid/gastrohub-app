class PaymentPlan {
  final int id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyDiscount;
  final int? maxUsers;
  final List<String> features;

  PaymentPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyDiscount,
    this.maxUsers,
    required this.features,
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      monthlyPrice: json['monthlyPrice'].toDouble(),
      yearlyDiscount: json['yearlyDiscount'].toDouble(),
      maxUsers: json['maxUsers'],
      features: List<String>.from(json['features']),
    );
  }
}