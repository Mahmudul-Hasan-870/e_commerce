import 'package:e_commerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import '../../widgets/category/category_app_bar.dart';
import '../../widgets/category/category_list.dart';
import '../../widgets/category/empty_categories.dart';
import '../../widgets/shimmer/shimmer_effect.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CategoryAppBar(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => categoryController.fetchCategories(),
          child: Obx(() {
            if (categoryController.isLoading.value) {
              return buildCategoryShimmerEffect(context);
            }

            if (categoryController.categories.isEmpty) {
              return const EmptyCategories();
            }

            return CategoryList(
              categories: categoryController.categories,
            );
          }),
        ),
      ),
    );
  }
}
