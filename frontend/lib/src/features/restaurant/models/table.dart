class RestaurantTable {
  final int id;
  final int layoutId;
  final int number;
  final int capacity;
  final String state;

  RestaurantTable({
    required this.id,
    required this.layoutId,
    required this.number,
    required this.capacity,
    required this.state,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: json['id'] as int,
      layoutId: json['layoutId'] as int,
      number: json['number'] as int,
      capacity: json['capacity'] as int,
      state: json['state'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'layoutId': layoutId,
      'number': number,
      'capacity': capacity,
      'state': state,
    };
  }
}
