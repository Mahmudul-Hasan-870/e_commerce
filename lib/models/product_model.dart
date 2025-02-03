import '../utils/config.dart';

class ProductModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double? salePrice;
  final int stock;
  final String image;
  final List<String> colors;
  final List<String> sizes;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.salePrice,
    required this.stock,
    required this.image,
    required this.colors,
    required this.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] is String ? int.tryParse(json['_id']) ?? 0 : json['_id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: json['price'] is String
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : json['price'].toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] is String
          ? double.tryParse(json['salePrice'].toString())
          : json['salePrice'].toDouble())
          : null,
      stock: json['stock'],
      image: '${AppConfig.baseUrl}/uploads/${json['image']}',
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
    );
  }
}
