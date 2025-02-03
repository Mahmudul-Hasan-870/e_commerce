import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/utils/colors.dart';
import 'package:e_commerce/views/shipping/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

import '../../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Text('Shopping Cart',
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
        actions: [
          IconButton(
            onPressed: () async {
              // Clear all items from the cart
              await cartController.clearCart();
              // Show confirmation message
              Get.snackbar(
                  'Cart Cleared', 'All items have been removed from your cart');
            },
            icon: Icon(
              IconlyLight.delete,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Obx(() {
        final cartItems = cartController.getCartItems();

        if (cartItems.isEmpty) {
          // Display Lottie animation when cart is empty
          return Center(
            child: Lottie.asset(
              'assets/lottie/no_items.json',
              width: 500,
              height: 500,
            ),
          );
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
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 25.0,
                left: 15.0,
                right: 15.0,
              ),
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
                      onPressed: () {
                        // Handle "Buy Now" action
                        Get.to(() => AddressScreen());
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
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String size;
  final int index;

  const CartItemWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.size,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          const SizedBox(width: 10),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$ $price",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Size: $size",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Quantity Adjuster and Delete Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        cartController.decreaseQuantity(index);
                      },
                      icon: const Icon(
                        Iconsax.minus,
                        size: 11,
                      ),
                    ),
                    Obx(() {
                      final quantity =
                          cartController.getCartItems()[index].quantity;
                      return Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        cartController.increaseQuantity(index);
                      },
                      icon: const Icon(
                        Iconsax.add,
                        size: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  cartController.removeFromCart(index);
                },
                icon: const Icon(IconlyLight.delete),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
