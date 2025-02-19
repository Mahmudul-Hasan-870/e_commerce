import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class TrackOrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrackOrderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'My Orders',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          IconlyLight.arrow_left,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
