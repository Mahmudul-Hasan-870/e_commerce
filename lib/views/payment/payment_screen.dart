import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/delivery/delivery_card.dart';
import '../services/razorpay_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.find<CartController>();
  final PaymentController paymentController = Get.find<PaymentController>();

  @override
  void initState() {
    super.initState();

    // Initialize Razorpay
    RazorpayService.initialize(
      onSuccess: (PaymentSuccessResponse response) {
        Get.snackbar(
          'Success',
          'Payment completed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      },
      onFailure: (PaymentFailureResponse response) {
        Get.snackbar(
          'Payment Cancelled',
          response.message ?? 'Payment was cancelled or failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      },
      onWallet: (ExternalWalletResponse response) {
        Get.snackbar(
          'Info',
          'External wallet selected: ${response.walletName}',
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }

  @override
  void dispose() {
    RazorpayService.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Text('Payment',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final totalPrice = cartController.getTotalPrice();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Icons.currency_rupee,
                      'Razorpay',
                      'Pay using UPI, cards, or wallets',
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
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final selectedIndex = paymentController
                              .selectedPaymentOptionIndex.value;
                          if (selectedIndex == -1) {
                            Get.snackbar(
                                "Error", "Please select a payment option.");
                            return;
                          }

                          switch (selectedIndex) {
                            case 0: // Stripe
                              await paymentController
                                  .processPayment(totalPrice);
                              break;
                            case 1: // Razorpay
                              RazorpayService.makePayment(
                                amount: totalPrice,
                                description: 'Order Payment',
                                context: context,
                              );
                              break;
                            case 2: // COD
                              await paymentController
                                  .processOrder("cash_on_delivery");
                              break;
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
