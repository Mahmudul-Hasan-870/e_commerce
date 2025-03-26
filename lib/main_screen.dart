import 'package:e_commerce/utils/colors.dart';
import 'package:e_commerce/views/category/category_screen.dart';
import 'package:e_commerce/views/home/home_screen.dart';
import 'package:e_commerce/views/profile/profile_screen.dart';
import 'package:e_commerce/views/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            indicatorColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  IconlyLight.home,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  IconlyBold.home,
                  color: Colors.white,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  IconlyLight.category,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  IconlyBold.category,
                  color: Colors.white,
                ),
                label: 'Category',
              ),
              NavigationDestination(
                icon: Icon(
                  IconlyLight.heart,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  IconlyBold.heart,
                  color: Colors.white,
                ),
                label: 'Wishlist',
              ),
              NavigationDestination(
                icon: Icon(
                  IconlyLight.profile,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  IconlyBold.profile,
                  color: Colors.white,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];
}
