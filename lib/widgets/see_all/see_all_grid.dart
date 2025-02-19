import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../home/product_card.dart';

class SeeAllGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool showSaleProducts;

  const SeeAllGrid({
    super.key,
    required this.products,
    required this.showSaleProducts,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = showSaleProducts
        ? products.where((product) => product.salePrice != null).toList()
        : products;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.79,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(product: product);
      },
    );
  }
}
