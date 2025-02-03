import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/shimmer_effect.dart';
import '../details/product_details.dart';

class SellAllScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final bool showSaleProducts;

  SellAllScreen({super.key, required this.showSaleProducts});

  // Refresh logic
  Future<void> _refreshData() async {
    await productController.fetchProducts(); // Replace with your actual fetch method
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
          showSaleProducts ? 'Sale Products' : 'Popular Products',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        backgroundColor: AppColors.primaryColor,
        color: Colors.white,
        child: Obx(() {
          if (productController.isLoading.value) {
            return buildShimmerEffect(context); // Placeholder for the shimmer effect widget
          } else {
            // Filter products based on the showSaleProducts flag
            var productsToShow = showSaleProducts
                ? productController.productList
                .where((product) =>
            product.salePrice != null && product.salePrice! > 0)
                .toList()
                : productController.productList.toList();

            // Shuffle the product list to display randomly
            productsToShow.shuffle();

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.73,
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
                        salePrice: (product.salePrice ?? 0.0).toString(),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasSalePrice)
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              decoration: TextDecoration.lineThrough,
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
              ),
            );
          }
        }),
      ),
    );
  }
}
