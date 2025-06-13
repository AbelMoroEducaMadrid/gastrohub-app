class Unit {
  final int id;
  final String name;
  final String symbol;

  Unit({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }
}