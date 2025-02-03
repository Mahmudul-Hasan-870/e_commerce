import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/views/cart/cart.dart';
import 'package:e_commerce/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../utils/colors.dart';
import '../details/product_details.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final ProductController productController = Get.put(ProductController());

  CategoryDetailScreen({required this.categoryName});

  // Refresh logic
  Future<void> _refreshData() async {
    await productController
        .fetchProducts(); // Replace with your actual fetch method
  }

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
        centerTitle: false,
        scrolledUnderElevation: 0.0,
        title: Text(
          categoryName,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: Colors.white,
          onRefresh: _refreshData,
          child: Obx(() {
            if (productController.isLoading.value) {
              return buildShimmerEffect(context);
            } else {
              // Filter products by category
              var categoryProducts = productController.productList
                  .where((product) => product.category == categoryName)
                  .toList();

              if (categoryProducts.isEmpty) {
                return Center(
                    child: Text("No products found in this category."));
              }

              var shuffledProducts = categoryProducts.toList()..shuffle();
              var productsToShow = shuffledProducts.take(6).toList();

              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.79,
                ),
                itemCount: productsToShow.length,
                itemBuilder: (context, index) {
                  var product = productsToShow[index];
                  bool hasSalePrice =
                      product.salePrice != null && product.salePrice! > 0;

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ProductDetailsScreen(
                        productName: product.name,
                        productImage: product.image,
                        productPrice: product.price.toString(),
                        salePrice:
                        (product.salePrice ?? 0.0).toString(),
                        stockQuantity: product.stock.toString(),
                        productDescription: product.description,
                        colors: product.colors,
                        sizes: product.sizes,
                      ));
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
                                    imageUrl: product.image,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasSalePrice)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$${product.salePrice}',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            '\$${product.price}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.0,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Text(
                                        '\$${product.price}',
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
                                    horizontal: 8.0, vertical: 4.0),
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
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
