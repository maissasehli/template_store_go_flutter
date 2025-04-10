class WishlistItem {
  final String id;
  final String name;
  final String description;
  final double price;
  int quantity;
  bool isSelected;

  WishlistItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
  });

  // ✅ Factory constructor for JSON parsing
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] is String
              ? double.tryParse(json['price'].replaceAll('\$', ''))
              : json['price'] is int
                ? (json['price'] as int).toDouble()
                : json['price']) ?? 0.0,
      quantity: json['quantity'] is int ? json['quantity'] : 1,
      isSelected: json['isSelected'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price, 
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }
}
