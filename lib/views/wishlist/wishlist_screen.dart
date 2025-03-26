import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/wishlist_controller.dart';
import '../../widgets/shimmer/shimmer_effect.dart';
import '../../widgets/wishlist/wishlist_app_bar.dart';
import '../../widgets/wishlist/wishlist_grid.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController wishlistController = Get.put(WishlistController());

  WishlistScreen({super.key});

  Future<void> _refreshWishlist() async {
    await wishlistController.loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WishlistAppBar(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshWishlist,
          color: AppColors.primaryColor,
          child: Obx(() {
            if (wishlistController.isLoading.value) {
              return buildShimmerEffect(context);
            }

            if (wishlistController.wishlistItems.isEmpty) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyBold.heart,
                          size: 100,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your Wishlist is Empty',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save items you like in your wishlist',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // This ListView enables pull-to-refresh even when empty
                  ListView(),
                ],
              );
            }

            return WishlistGrid(
              items: wishlistController.wishlistItems,
              controller: wishlistController,
            );
          }),
        ),
      ),
    );
  }
}
