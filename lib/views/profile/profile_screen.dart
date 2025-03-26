import 'package:e_commerce/views/track_order/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/user_controller.dart';
import '../../widgets/profile/profile_app_bar.dart';
import '../../widgets/profile/profile_bottom_section.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController userController = Get.put(UserController());
  final ProfileBottomSection bottomSection = const ProfileBottomSection();

  @override
  Widget build(BuildContext context) {
    // Fetch user data when the screen is built
    userController.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const Divider(),
            ProfileMenuItem(
              icon: IconlyBold.profile,
              iconColor: const Color(0xFF7267CB), // Deep Purple
              title: 'Edit Profile',
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: IconlyBold.buy,
              iconColor: const Color(0xFF4CAF50), // Material Green
              title: 'My Orders',
              onTap: () {
                // Handle My Orders tap
                Get.to(() => TrackOrderScreen());
              },
            ),
            ProfileMenuItem(
              icon: IconlyBold.shield_done,
              iconColor: const Color(0xFF2196F3), // Material Blue
              title: 'Privacy Policy',
              onTap: bottomSection.showPrivacyPolicy,
            ),
            ProfileMenuItem(
              icon: IconlyBold.paper,
              iconColor: const Color(0xFFFF9800), // Material Orange
              title: 'Terms of Service',
              onTap: bottomSection.showTermsOfService,
            ),
            ProfileMenuItem(
              icon: IconlyBold.logout,
              iconColor: const Color(0xFFE53935), // Material Red
              title: 'Logout',
              onTap: () {
                // Handle Logout tap
              },
            ),
            const ProfileBottomSection(),
          ],
        ),
      ),
    );
  }
}
