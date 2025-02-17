import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/category/category_detail_app_bar.dart';
import '../../widgets/category/category_detail_body.dart';
import '../../utils/colors.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final ProductController productController = Get.find<ProductController>();
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshProducts() async {
    await productController.fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CategoryDetailAppBar(categoryName: widget.categoryName),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshProducts,
          color: AppColors.primaryColor,
          child: CategoryDetailBody(
            categoryName: widget.categoryName,
            productController: productController,
            scrollController: _scrollController,
          ),
        ),
      ),
    );
  }
}
