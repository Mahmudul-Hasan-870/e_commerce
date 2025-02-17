import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/see_all/see_all_app_bar.dart';
import '../../widgets/see_all/see_all_grid.dart';
import '../../widgets/shimmer_effect.dart';

class SeeAllScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final bool showSaleProducts;

  SeeAllScreen({super.key, required this.showSaleProducts});

  Future<void> _refreshData() async {
    await productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeeAllAppBar(showSaleProducts: showSaleProducts),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primaryColor,
          child: Obx(() {
            if (productController.isLoading.value) {
              return buildShimmerEffect(context);
            }

            return SeeAllGrid(
              products: productController.productList,
              showSaleProducts: showSaleProducts,
            );
          }),
        ),
      ),
    );
  }
}
