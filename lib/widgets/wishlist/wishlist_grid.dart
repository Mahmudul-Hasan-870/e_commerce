import 'package:flutter/material.dart';

import '../../controllers/wishlist_controller.dart';
import '../../models/wishlist_model.dart';
import 'wishlist_item_card.dart';

class WishlistGrid extends StatelessWidget {
  final List<WishlistModel> items;
  final WishlistController controller;

  const WishlistGrid({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.79,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return WishlistItemCard(
          item: items[index],
          controller: controller,
        );
      },
    );
  }
}
