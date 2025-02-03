import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/product_details_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/cart_model.dart';
import '../../models/wishlist_model.dart';
import '../../utils/colors.dart';
import '../cart/cart.dart';
import '../shipping/address_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  final String productImage;
  final String productPrice;
  final String salePrice;
  final String productDescription;
  final String? stockQuantity;
  final List<String> colors;
  final List<String> sizes;

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.salePrice,
    required this.productDescription,
    this.stockQuantity,
    required this.colors,
    required this.sizes,
  });

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController productController =
        Get.put(ProductDetailsController());
    final CartController cartController = Get.find<CartController>();
    final WishlistController wishlistController = Get.put(WishlistController());

    bool isInWishlist = wishlistController.isInWishlist(productName);

    final hasSalePrice = (double.tryParse(salePrice) ?? 0) > 0;
    final stockQuantityInt = int.tryParse(stockQuantity ?? '') ?? 0;

    String stockMessage;
    if (stockQuantity == null || stockQuantityInt == 0) {
      stockMessage = 'No Stock';
    } else if (stockQuantityInt > 3) {
      stockMessage = 'In Stock';
    } else if (stockQuantityInt > 0 && stockQuantityInt <= 3) {
      stockMessage = 'Ready Stock';
    } else {
      stockMessage = 'No Stock';
    }

    final double productPriceDouble = double.tryParse(productPrice) ?? 0.0;
    final double salePriceDouble = double.tryParse(salePrice) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
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
            onPressed: () {
              if (isInWishlist) {
                // Remove from Wishlist
                final wishlistItem = wishlistController.wishlistItems
                    .firstWhere((item) => item.productName == productName);
                wishlistController.removeFromWishlist(wishlistItem);
                Get.snackbar('Removed', 'Item removed from Wishlist');
              } else {
                // Add to Wishlist
                final wishlistItem = WishlistModel(
                  productName: productName,
                  productImage: productImage,
                  productPrice: (double.tryParse(salePrice) ?? 0) > 0
                      ? salePrice // Use sale price if it's available
                      : productPrice, // Fallback to regular price
                );
                wishlistController.addToWishlist(wishlistItem);
                Get.snackbar('Added', 'Item added to Wishlist');
              }
              // Toggle the heart icon
              isInWishlist = !isInWishlist;
            },
            icon: Obx(() {
              return Icon(
                wishlistController.isInWishlist(productName)
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                color: wishlistController.isInWishlist(productName)
                    ? Colors.red
                    : Colors.black,
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 350.0,
                      child: CachedNetworkImage(
                        imageUrl: productImage,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                                color: AppColors.primaryColor),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      productName,
                      style: GoogleFonts.poppins(
                          fontSize: 24.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasSalePrice)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$${salePriceDouble.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      '\$${productPriceDouble.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  '\$${productPriceDouble.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              stockMessage,
                              style: GoogleFonts.poppins(
                                color: stockQuantity == null ||
                                        stockQuantityInt == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    // Choose Color Section
                    Text(
                      'Choose Color:',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    CustomColorSelector(
                      colors: colors,
                      selectedColor: productController.selectedColor.value,
                      onColorSelected: (color) {
                        productController.setColor(color, sizes);
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // Choose Size Section
                    if (productController.selectedColor.value != null) ...[
                      Text(
                        'Choose Size:',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      CustomSizeSelector(
                        sizes: productController.availableSizes,
                        selectedSize: productController.selectedSize.value,
                        onSizeSelected: (size) {
                          productController.setSize(size);
                        },
                      ),
                      const SizedBox(height: 20.0),
                    ],

                    // Product Description Section
                    Text(
                      productDescription,
                      style: GoogleFonts.poppins(fontSize: 16.0),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 25.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Retrieve controllers
                      final CartController cartController =
                          Get.find<CartController>();
                      final ProductDetailsController productController =
                          Get.find<ProductDetailsController>();

                      if (productController.selectedColor.value != null &&
                          productController.selectedSize.value != null) {
                        // Create the CartModel item
                        final cartItem = CartModel(
                          imageUrl: productImage,
                          title: productName,
                          price: hasSalePrice
                              ? salePriceDouble.toStringAsFixed(2)
                              : productPriceDouble.toStringAsFixed(2),
                          color: productController.selectedColor.value!,
                          size: productController.selectedSize.value!,
                        );

                        // Add the item to the in-memory cart using GetX
                        await cartController.addToCart(cartItem);

                        // Show success message
                        Get.snackbar('Success', 'Item added to cart');

                        // Navigate to the CartScreen
                        Get.to(() => const CartScreen());
                      } else {
                        // Show error message if color or size is not selected
                        Get.snackbar('Selection Missing',
                            'Please select both color and size');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      IconlyLight.buy,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (productController.selectedColor.value != null &&
                            productController.selectedSize.value != null) {
                          // Handle "Buy Now" action
                          cartController.addToCart(CartModel(
                            imageUrl: productImage,
                            title: productName,
                            price: hasSalePrice
                                ? salePriceDouble.toStringAsFixed(2)
                                : productPriceDouble.toStringAsFixed(2),
                            color: productController.selectedColor.value!,
                            size: productController.selectedSize.value!,
                          ));
                          Get.to(() => AddressScreen());
                        } else {
                          Get.snackbar('Selection Missing',
                              'Please select both color and size');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        textStyle: GoogleFonts.poppins(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
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

class CustomColorSelector extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String?> onColorSelected;

  const CustomColorSelector({
    Key? key,
    required this.colors,
    this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.map((color) {
          return GestureDetector(
            onTap: () {
              onColorSelected(selectedColor == color ? null : color);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              height: 40.0,
              width: 80.0,
              decoration: BoxDecoration(
                color: selectedColor == color
                    ? AppColors.primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  color,
                  style: GoogleFonts.poppins(
                    color: selectedColor == color ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String?> onSizeSelected;

  const CustomSizeSelector({
    Key? key,
    required this.sizes,
    this.selectedSize,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        return GestureDetector(
          onTap: () {
            onSizeSelected(selectedSize == size ? null : size);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: selectedSize == size
                  ? AppColors.primaryColor
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                size,
                style: GoogleFonts.poppins(
                  color: selectedSize == size ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
