import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class SeeAllAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSaleProducts;

  const SeeAllAppBar({super.key, required this.showSaleProducts});

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
        showSaleProducts ? 'Flash Sale' : 'New Arrivals',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
