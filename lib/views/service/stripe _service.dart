import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

import '../../utils/config.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(double totalPrice) async {
    try {
      // Create PaymentIntent and get client secret
      String? paymentIntentClientSecret = await _createPaymentIntent(
        totalPrice,
        "usd",
      );
      if (paymentIntentClientSecret == null) return;

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: AppConfig.appName,
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
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
      } else {
        print("Failed to create payment intent: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}
