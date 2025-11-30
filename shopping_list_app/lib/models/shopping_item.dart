class ShoppingItem {
  String id;
  String name;
  int quantity;
  String category;
  bool isPurchased;
  DateTime createdAt;
  DateTime updatedAt;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.isPurchased,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      category: json['category'],
      isPurchased: json['isPurchased'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isPurchased': isPurchased,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ShoppingItem copyWith({
    String? name,
    int? quantity,
    String? category,
    bool? isPurchased,
    DateTime? updatedAt,
  }) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
