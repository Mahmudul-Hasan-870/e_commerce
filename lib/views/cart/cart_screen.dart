import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/cart_controller.dart';
import '../../widgets/cart/cart_app_bar.dart';
import '../../widgets/cart/cart_bottom_bar.dart';
import '../../widgets/cart/cart_item_widget.dart';
import '../../widgets/cart/empty_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: const CartAppBar(),
      body: Obx(() {
        if (cartController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final cartItems = cartController.getCartItems();

        if (cartItems.isEmpty) {
          return const EmptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemWidget(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    price: item.price,
                    size: item.size,
                    index: index,
                  );
                },
              ),
            ),
            const CartBottomBar(),
          ],
        );
      }),
    );
  }
}
