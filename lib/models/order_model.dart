import 'item.dart';

class Order {
  final int id;
  final List<Item> items; // List of Item instances
  final String deliveryAddress;
  final String deliveryOption;
  final String paymentStatus;
  final double totalAmount;
  final String orderStatus;
  final String createdAt;

  Order({
    required this.id,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryOption,
    required this.paymentStatus,
    required this.totalAmount,
    required this.orderStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson)) // Handle each item
          .toList(),
      deliveryAddress: json['delivery_address'] ?? 'No address provided', // Provide default value
      deliveryOption: json['delivery_option'] ?? 'Standard', // Default value
      paymentStatus: json['payment_status'] ?? 'unknown', // Default value
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0, // Safely convert to double
      orderStatus: json['order_status'] ?? 'pending', // Default value
      createdAt: json['created_at'] ?? '', // Ensure it’s not null
    );
  }
}
