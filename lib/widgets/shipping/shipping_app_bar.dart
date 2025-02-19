import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class ShippingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditing;

  const ShippingAppBar({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      title: Text(
        isEditing ? 'Edit Shipping Address' : 'Shipping Address',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          IconlyLight.arrow_left,
          color: Colors.black,
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
