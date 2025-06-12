class Layout {
  final int id;
  final String name;

  Layout({required this.id, required this.name});

  factory Layout.fromJson(Map<String, dynamic> json) {
    return Layout(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
