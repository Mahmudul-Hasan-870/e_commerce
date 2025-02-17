import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../../controllers/cart_controller.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return AppBar(
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      title: Text(
        'Shopping Cart',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
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
      actions: [
        IconButton(
          onPressed: () async {
            await cartController.clearCart();
            Get.snackbar('Cart Cleared', 'All items have been removed from your cart');
          },
          icon: const Icon(
            IconlyLight.delete,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 