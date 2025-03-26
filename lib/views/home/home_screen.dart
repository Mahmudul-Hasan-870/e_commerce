import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:e_commerce/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/home/image_carousel.dart';
import '../../widgets/home/product_grid.dart';
import '../../widgets/home/section_title.dart';
import '../see_all/see_all_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  HomeScreen({super.key});

  Future<void> _refreshProducts() async {
    await Future.wait([
      productController.fetchProducts(),
      productController.fetchBanners(),
    ]);
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

              final bannerImages = productController.bannerList
                  .map((banner) => banner.image.startsWith('http')
                      ? banner.image
                      : '${AppConfig.baseUrl}/uploads/banners/${banner.image}')
                  .toList();

              return Column(
                children: [
                  const SizedBox(height: 10),
                  if (bannerImages.isEmpty)
                    Container(
                      height: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  else
                    ImageCarousel(
                      imageList: bannerImages,
                      imageBuilder: (context, index) {
                        return Image.network(
                          bannerImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error_outline,
                                    color: Colors.grey),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  SectionTitle(
                    title: 'Flash Sale',
                    onSeeAll: () =>
                        Get.to(() => SeeAllScreen(showSaleProducts: true)),
                  ),
                  ProductGrid(
                    products: productController.productList,
                    showSaleItems: true,
                  ),
                  SectionTitle(
                    title: 'New Arrivals',
                    onSeeAll: () =>
                        Get.to(() => SeeAllScreen(showSaleProducts: false)),
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
