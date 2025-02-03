import 'package:hive/hive.dart';

part 'cart_model.g.dart'; // Required for generating the adapter

@HiveType(typeId: 1) // Assign a unique typeId for CartModel
class CartModel {
  @HiveField(0)
  final String imageUrl;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String price;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final String size;

  @HiveField(5)
  int quantity;

  CartModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.color,
    required this.size,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'color': color,
      'size': size,
      'quantity': quantity,
    };
  }
}
