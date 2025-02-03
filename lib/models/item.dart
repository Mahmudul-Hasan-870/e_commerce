// item.dart
class Item {
  final String name;
  final int quantity;
  final double price;

  Item({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['title'] ?? 'Unknown Item', // Provide a default value if null
      quantity: json['quantity'] ?? 0, // Default to 0 if null
      price: double.tryParse(json['price'].toString()) ?? 0.0, // Safely convert string to double
    );
  }
}
