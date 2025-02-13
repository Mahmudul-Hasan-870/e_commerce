import 'dart:convert';
import 'package:e_commerce/controllers/prefs_controller.dart';
import 'package:e_commerce/controllers/shipping_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:e_commerce/views/success/success.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/onder_model.dart';
import '../views/service/stripe _service.dart';
import 'cart_controller.dart';

class PaymentController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final ShippingController shippingController = Get.find<ShippingController>();
  final SharedPreferencesController prefsController = SharedPreferencesController();

  RxInt selectedPaymentOptionIndex = RxInt(-1);

  // Handle payment process
  Future<void> processPayment(double amount) async {
    final selectedOptionIndex = selectedPaymentOptionIndex.value;

    if (selectedOptionIndex == -1) {
      Get.snackbar("Error", "Please select a payment option.");
      return;
    }

    try {
      if (selectedOptionIndex == 0) { // Stripe payment option
        await StripeService.instance.makePayment(amount);
        // Only process order after successful payment
        await processOrder("success");
      } else if (selectedOptionIndex == 2) { // Cash on Delivery option
        await processOrder("cash_on_delivery");
      } else {
        Get.snackbar("Error", "Selected payment option is not available.");
        return;
      }
    } catch (e) {
      Get.snackbar("Error", "Payment failed: $e");
      return;
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
        'items': cartController.getCartItems().map((item) => {
          'product_name': item.title,
          'quantity': item.quantity,
          'price': item.price,
          'total': (double.parse(item.price) * item.quantity).toString(),
          'image_url': item.imageUrl,
          'color': item.color,
          'size': item.size,
        }).toList(),
        'delivery_address': {
          'first_name': selectedAddress.firstName,
          'last_name': selectedAddress.lastName,
          'phone_number': selectedAddress.phoneNumber,
          'address': selectedAddress.address,
          'city': selectedAddress.city,
          'country': selectedAddress.country,
          'state': selectedAddress.state,
          'postal_code': selectedAddress.postalCode
        },
        'delivery_option': selectedDeliveryOption,
        'payment_status': paymentStatus,
        'order_status': paymentStatus == "cash_on_delivery" ? "pending" : "processed",
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

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}"); // For debugging

      if (response.statusCode == 200 || response.statusCode == 201) {
        await cartController.clearCart();
        // Show success message based on payment type
        if (paymentStatus == "success") {
          Get.snackbar(
            "Success", 
            "Payment and order processed successfully!",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Success", 
            "Order placed successfully!",
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );
        }
        Get.to(() => OrderConfirmationScreen(deliveryOption: selectedDeliveryOption));
      } else {
        Get.snackbar(
          'Error', 
          'Failed to place the order. Please try again.',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      }
    } catch (error) {
      print("Error details: $error"); // For debugging
      Get.snackbar(
        'Error', 
        'An error occurred while processing your order. Please try again.',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
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
