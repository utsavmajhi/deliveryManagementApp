class Warehouse {
  final String id;
  final String name;

  Warehouse({
    required this.id,
    required this.name,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  Warehouse copyWith({
    String? id,
    String? name,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}