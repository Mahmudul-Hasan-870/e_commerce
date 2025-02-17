import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../home/product_grid.dart';
import '../shimmer_effect.dart';

class CategoryDetailBody extends StatelessWidget {
  final String categoryName;
  final ProductController productController;
  final ScrollController scrollController;

  const CategoryDetailBody({
    Key? key,
    required this.categoryName,
    required this.productController,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Obx(() {
          if (productController.isLoading.value) {
            return buildShimmerEffect(context);
          }

          final categoryProducts = productController.productList
              .where((product) => product.category == categoryName)
              .toList();

          if (categoryProducts.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  'No products found in this category',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          return ProductGrid(
            products: categoryProducts,
            showSaleItems: false,
          );
        }),
      ),
    );
  }
} 