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

    if (selectedOptionIndex == 0) { // Stripe payment option
      try {
        await StripeService.instance.makePayment(amount);
        await processOrder("success");
        Get.snackbar("Success", "Payment processed successfully!");
      } catch (e) {
        Get.snackbar("Error", "Payment failed: $e");
      }
    } else if (selectedOptionIndex == 2) { // Cash on Delivery option
      await processOrder("cash_on_delivery");
      Get.snackbar("Success", "Order placed successfully!");
    } else {
      Get.snackbar("Error", "Selected payment option is not available.");
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

    final selectedAddress = shippingController
        .addresses[shippingController.selectedAddressIndex.value];
    final selectedDeliveryOption = getDeliveryOption(shippingController.selectedDeliveryOptionIndex.value);

    // Calculate the total amount for the order
    final double totalAmount = cartController.getTotalPrice();

    final order = OrderModel(
      items: cartController.getCartItems(),
      deliveryAddress: selectedAddress,
      deliveryOption: selectedDeliveryOption,
      paymentStatus: paymentStatus,
      orderStatus: paymentStatus == "cash_on_delivery" ? "pending" : "processed",
      totalAmount: totalAmount, // Set totalAmount here
    );

    try {
      final response = await http.post(
        Uri.parse(AppConfig.productsOrdersUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(order.toJson()),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        Get.to(() => OrderConfirmationScreen(deliveryOption: selectedDeliveryOption));
        await cartController.clearCart();
      } else {
        Get.snackbar('Error', 'Failed to place the order: ${response.body}');
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: $error');
      print("Error: $error");
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
