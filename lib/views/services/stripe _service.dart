import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/config.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(double totalPrice) async {
    try {
      // Create PaymentIntent and get client secret
      String? paymentIntentClientSecret = await _createPaymentIntent(
        totalPrice,
        "usd",
      );

      if (paymentIntentClientSecret == null) {
        Get.snackbar(
          'Error',
          'Could not initialize payment',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: AppConfig.appName,
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Don't navigate here, just return order_confirmation
      Get.snackbar(
        'Success',
        'Payment completed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
      return true;
    } catch (e) {
      if (e is StripeException) {
        if (e.error.code == 'Cancelled') {
          Get.snackbar(
            'Cancelled',
            'Payment was cancelled',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange[100],
            colorText: Colors.orange[900],
          );
        } else {
          Get.snackbar(
            'Error',
            e.error.localizedMessage ?? 'Payment failed',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Something went wrong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
      print('Error: $e');
      return false;
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Map<String, String> headers = {
        "Authorization": "Bearer ${AppConfig.stripeSecretKey}",
        "Content-Type": 'application/x-www-form-urlencoded',
      };
      final Map<String, String> body = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["client_secret"];
      } else {}
    } catch (e) {}
    return null;
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}
