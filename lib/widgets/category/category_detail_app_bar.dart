import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../views/cart/cart.dart';

class CategoryDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String categoryName;

  const CategoryDetailAppBar({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        categoryName,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const CartScreen());
          },
          icon: const Icon(IconlyBold.buy),
          color: Colors.black,
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
