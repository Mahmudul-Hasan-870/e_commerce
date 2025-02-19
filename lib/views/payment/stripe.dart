import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/delivery/delivery_card.dart';

class StripePaymentPage extends StatelessWidget {
  const StripePaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final PaymentController paymentController = Get.find<PaymentController>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Text('Payment',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            IconlyLight.arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final totalPrice = cartController.getTotalPrice();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Option Cards
              Expanded(
                child: ListView(
                  children: [
                    deliveryOptionCard(
                      Icons.payment,
                      'Stripe',
                      'Pay securely with Stripe',
                      paymentController.selectedPaymentOptionIndex.value == 0,
                      () => paymentController.selectPaymentOption(0),
                    ),
                    const SizedBox(height: 10),
                    deliveryOptionCard(
                      Icons.paypal,
                      'PayPal',
                      'Secure online payments',
                      paymentController.selectedPaymentOptionIndex.value == 1,
                      () => paymentController.selectPaymentOption(1),
                    ),
                    const SizedBox(height: 10),
                    deliveryOptionCard(
                      Icons.money_off,
                      'Cash on Delivery',
                      'Pay in cash when you receive your order',
                      paymentController.selectedPaymentOptionIndex.value == 2,
                      () => paymentController.selectPaymentOption(2),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Total Price',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Obx(() {
                            final totalPrice = cartController.getTotalPrice();
                            return Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final selectedPaymentOptionIndex = paymentController
                              .selectedPaymentOptionIndex.value;
                          if (selectedPaymentOptionIndex == -1) {
                            Get.snackbar(
                                "Error", "Please select a payment option.");
                          } else {
                            await paymentController.processPayment(totalPrice);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
