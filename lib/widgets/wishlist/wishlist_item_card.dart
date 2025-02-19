import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/wishlist_model.dart';
import '../../views/details/product_details.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistModel item;
  final WishlistController controller;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final product = productController.productList
        .firstWhereOrNull((p) => p.name == item.productName);
    final bool hasSalePrice =
        product?.salePrice != null && product!.salePrice! > 0;

    return GestureDetector(
      onTap: () {
        if (product != null) {
          Get.to(() => ProductDetailsScreen(
                productName: product.name,
                productImage: product.image,
                productPrice: product.price.toString(),
                salePrice: product.salePrice?.toString() ?? '',
                productDescription: product.description,
                stockQuantity: product.stock.toString(),
                colors: product.colors,
                sizes: product.sizes,
              ));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                  height: 170,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                // Product Details Section
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (hasSalePrice) ...[
                        Row(
                          children: [
                            Text(
                              '\$${product!.salePrice}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${product.price}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          '\$${item.productPrice}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Sale Label
            if (hasSalePrice)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SALE',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            // Remove from Wishlist Button
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    IconlyBold.heart,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => controller.removeFromWishlist(item),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
