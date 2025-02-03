import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/wishlist_controller.dart';
import '../../utils/colors.dart';
import '../cart/cart.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: const Icon(IconlyBold.buy),
            color: Colors.black,
          ),
        ],
        centerTitle: false,
        scrolledUnderElevation: 0.0,
        title: Text(
          'Wishlist',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (wishlistController.wishlistItems.isEmpty) {
          return Center(
            child: Text(
              'Your Wishlist is Empty',
              style: GoogleFonts.poppins(fontSize: 18.0),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.79,
          ),
          itemCount: wishlistController.wishlistItems.length,
          itemBuilder: (context, index) {
            final wishlistItem = wishlistController.wishlistItems[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Stack(
                children: [
                  // Main content of the card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image container
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 150.0,
                          child: CachedNetworkImage(
                            imageUrl: wishlistItem.productImage,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, color: Colors.red),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Product name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          wishlistItem.productName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      // Price display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$${wishlistItem.productPrice}',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0.0,
                    child: Obx(() {
                      return IconButton(
                        icon: Icon(
                          wishlistController
                                  .isInWishlist(wishlistItem.productName)
                              ? IconlyBold.heart
                              : IconlyLight.heart,
                          color: wishlistController
                                  .isInWishlist(wishlistItem.productName)
                              ? Colors.red
                              : Colors.black,
                        ),
                        onPressed: () {
                          wishlistController.removeFromWishlist(wishlistItem);
                          Get.snackbar('Removed', 'Item removed from Wishlist');
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
