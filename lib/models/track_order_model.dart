class TrackOrderModel {
  final String id;
  final List<OrderItem> items;
  final List<DeliveryAddress> deliveryAddress;
  final String deliveryOption;
  final String paymentStatus;
  final String orderStatus;
  final double totalAmount;
  final String createdAt;

  TrackOrderModel({
    required this.id,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryOption,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalAmount,
    required this.createdAt,
  });

  factory TrackOrderModel.fromJson(Map<String, dynamic> json) {
    return TrackOrderModel(
      id: json['_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      deliveryAddress: (json['delivery_address'] as List)
          .map((address) => DeliveryAddress.fromJson(address))
          .toList(),
      deliveryOption: json['delivery_option'],
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      totalAmount: json['total_amount'] != null 
          ? double.tryParse(json['total_amount'].toString()) ?? 0.0 
          : _calculateTotalFromItems(json['items'] as List),
      createdAt: json['createdAt'],
    );
  }

  static double _calculateTotalFromItems(List items) {
    return items.fold(0.0, (total, item) {
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      return total + (price * quantity);
    });
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final String price;
  final String total;
  final String imageUrl;
  final String color;
  final String size;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
    required this.imageUrl,
    required this.color,
    required this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
      imageUrl: json['image_url'],
      color: json['color'],
      size: json['size'],
    );
  }
}

class DeliveryAddress {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;
  final String country;
  final String state;
  final String postalCode;

  DeliveryAddress({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.country,
    required this.state,
    required this.postalCode,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      state: json['state'],
      postalCode: json['postal_code'],
    );
  }
} 