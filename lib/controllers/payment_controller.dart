import 'dart:convert';
import 'package:e_commerce/controllers/local_controller.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/controllers/shipping_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../views/services/stripe _service.dart';
import '../views/success/success.dart';
import 'cart_controller.dart';

class PaymentController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final ShippingController shippingController = Get.find<ShippingController>();
  final SharedPreferencesController prefsController =
      SharedPreferencesController();

  final selectedPaymentOptionIndex = (-1).obs;

  // Handle payment process
  Future<void> processPayment(double amount) async {
    try {
      // Stripe payment
      bool paymentSuccess = await StripeService.instance.makePayment(amount);

      // Only process order if payment was successful
      if (paymentSuccess) {
        await processOrder("order_confirmation");
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Payment processing failed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Select a payment option
  void selectPaymentOption(int index) {
    selectedPaymentOptionIndex.value = index;
  }

  // Process the order after successful payment
  Future<void> processOrder(String paymentStatus) async {
    final token = await prefsController.getToken();
    if (token == null) {
      Get.snackbar("Error", "Authentication required. Please log in.");
      return;
    }

    try {
      final selectedAddress = shippingController
          .addresses[shippingController.selectedAddressIndex.value];
      final selectedDeliveryOption = getDeliveryOption(
          shippingController.selectedDeliveryOptionIndex.value);

      final double totalAmount = cartController.getTotalPrice();

      // Create order data in the format expected by the API
      final orderData = {
        'items': cartController
            .getCartItems()
            .map((item) => {
                  'product_name': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                  'total':
                      (double.parse(item.price) * item.quantity).toString(),
                  'image_url': item.imageUrl,
                  'color': item.color,
                  'size': item.size,
                })
            .toList(),
        'delivery_address': {
          'firstName': selectedAddress.firstName,
          'lastName': selectedAddress.lastName,
          'phoneNumber': selectedAddress.phoneNumber,
          'address': selectedAddress.address,
          'city': selectedAddress.city,
          'country': selectedAddress.country,
          'state': selectedAddress.state,
          'postal_code': selectedAddress.postalCode
        },
        'delivery_option': selectedDeliveryOption,
        'payment_status': paymentStatus,
        'order_status': paymentStatus == "cash_on_delivery"
            ? "pending"
            : "processed", // For successful payment, status will be 'processed'
        'total_amount': totalAmount,
      };

      final response = await http.post(
        Uri.parse(AppConfig.productsOrdersUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await cartController.clearCart();

        // Navigate to order_confirmation screen with delivery option
        Get.offAll(
          () => OrderConfirmationScreen(
            deliveryOption: selectedDeliveryOption,
          ),
        );

        // Show order_confirmation message based on payment type
        if (paymentStatus == "order_confirmation") {
          Get.snackbar(
            "Success",
            "Payment and order processed successfully!",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Success",
            "Order placed successfully!",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to place the order. Please try again.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'An error occurred while processing your order. Please try again.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Helper function to get the selected delivery option
  String getDeliveryOption(int index) {
    switch (index) {
      case 0:
        return 'Standard';
      case 1:
        return 'Express';
      default:
        return 'Unknown';
    }
  }
}
