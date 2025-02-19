import 'dart:convert';

import 'package:e_commerce/models/shipping_address_model.dart';

import 'cart_model.dart';

class OrderModel {
  final List<CartModel> items;
  final ShippingAddressModel deliveryAddress; // Keep this as an object
  final String deliveryOption;
  final String paymentStatus;
  final String orderStatus;
  final double totalAmount;

  OrderModel({
    required this.items,
    required this.deliveryAddress,
    required this.deliveryOption,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'delivery_address': jsonEncode(deliveryAddress.toJson()), // Convert to JSON string
      'delivery_option': deliveryOption,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'total_amount': totalAmount,
    };
  }
}
