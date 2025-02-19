import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool showSaleItems;

  const ProductGrid({
    super.key,
    required this.products,
    this.showSaleItems = false,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = showSaleItems
        ? products.where((product) => product.salePrice != null).toList()
        : products;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
