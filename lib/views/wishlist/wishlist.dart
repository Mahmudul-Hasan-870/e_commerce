import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../utils/colors.dart';
import '../cart/cart.dart';
import '../details/product_details.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController wishlistController = Get.put(WishlistController());
  final ProductController productController = Get.put(ProductController());

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
            final product = productController.productList.firstWhereOrNull(
              (p) => p.name == wishlistItem.productName
            );
            
            final bool hasSalePrice = product?.salePrice != null && product!.salePrice! > 0;

            return GestureDetector(
              onTap: () {
                if (product != null) {
                  Get.to(() => ProductDetailsScreen(
                    productName: product.name,
                    productImage: product.image,
                    productPrice: product.price.toString(),
                    salePrice: (product.salePrice ?? 0.0).toString(),
                    productDescription: product.description,
                    stockQuantity: product.stock.toString(),
                    colors: product.colors,
                    sizes: product.sizes,
                  ));
                }
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  const Icon(Icons.error, color: Colors.red),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            wishlistItem.productName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasSalePrice)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$${product!.salePrice}',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      '\$${product.price}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  '\$${wishlistItem.productPrice}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (hasSalePrice)
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            'Sale',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 0.0,
                      child: IconButton(
                        icon: const Icon(
                          IconlyBold.heart,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          wishlistController.removeFromWishlist(wishlistItem);
                          Get.snackbar('Removed', 'Item removed from Wishlist');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
