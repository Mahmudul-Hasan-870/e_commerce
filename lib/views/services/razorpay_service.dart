import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controllers/payment_controller.dart';
import '../../utils/config.dart';

class RazorpayService {
  static late final Razorpay _razorpay;
  static late final PaymentController _paymentController;

  static void init() {
    _razorpay = Razorpay();
    _paymentController = Get.find<PaymentController>();
  }

  static void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    init();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) async {
      onSuccess(response);
      await _paymentController.processOrder("order_confirmation");
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      onFailure(response);
      Get.back();
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  static void makePayment({
    required double amount,
    required String description,
    required BuildContext context,
  }) {
    try {
      var options = {
        'key': AppConfig.razorpayTestKey,
        'amount': (amount * 100).toInt(),
        'currency': 'INR',
        'name': AppConfig.appName,
        'description': description,
        'external': {
          'wallets': ['paytm', 'gpay']
        },
        'theme': {
          'color':
              '#${Theme.of(context).primaryColor.value.toRadixString(16).substring(2)}'
        }
      };

      _razorpay.open(options);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not initialize payment gateway',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      Get.back();
    }
  }

  static void clear() {
    _razorpay.clear();
  }
}
