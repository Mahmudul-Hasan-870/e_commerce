import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:e_commerce/views/cart/cart.dart';
import 'package:e_commerce/widgets/image_slider.dart';
import 'package:e_commerce/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../utils/colors.dart';
import '../details/product_details.dart';
import '../see_all/see_all.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/home/image_carousel.dart';
import '../../widgets/home/section_title.dart';
import '../../widgets/home/product_grid.dart';

class HomeScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  final List<String> imageList = [
    'https://images.remotehub.com/d42c62669a7711eb91397e038280fee0/1200x6000/ec1eb042.jpg',
    'https://images.remotehub.com/d42c62669a7711eb91397e038280fee0/1200x6000/ec1eb042.jpg',
    'https://images.remotehub.com/d42c62669a7711eb91397e038280fee0/1200x6000/ec1eb042.jpg',
  ];

  Future<void> _refreshProducts() async {
    await productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              if (productController.isLoading.value) {
                return buildHomeShimmerEffect(context);
              }

              return Column(
                children: [
                  const SizedBox(height: 10),
                  ImageCarousel(imageList: imageList),
                  const SizedBox(height: 20),
                  SectionTitle(
                    title: 'Flash Sale',
                    onSeeAll: () => Get.to(() => SeeAllScreen(showSaleProducts: true)),
                  ),
                  ProductGrid(
                    products: productController.productList,
                    showSaleItems: true,
                  ),
                  SectionTitle(
                    title: 'New Arrivals',
                    onSeeAll: () => Get.to(() => SeeAllScreen(showSaleProducts: false)),
                  ),
                  ProductGrid(
                    products: productController.productList,
                    showSaleItems: false,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
