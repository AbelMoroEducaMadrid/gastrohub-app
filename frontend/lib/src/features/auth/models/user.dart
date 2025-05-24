class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final int? restaurantId;
  final String? restaurantName;
  final String lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.restaurantId,
    required this.restaurantName,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      lastLogin: json['lastLogin'],
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    int? restaurantId,
    String? restaurantName,
    String? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
