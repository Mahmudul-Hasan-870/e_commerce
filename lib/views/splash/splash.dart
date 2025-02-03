import 'dart:async';

import 'package:e_commerce/utils/colors.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:e_commerce/views/auth/login/login.dart';
import 'package:e_commerce/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/prefs_controller.dart';
import '../../widgets/primary_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPreferencesController _prefsController =
      SharedPreferencesController();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for SharedPreferences to load
    await Future.delayed(const Duration(seconds: 2)); // Simulate a splash delay

    // Retrieve token from SharedPreferences
    String? token = await _prefsController.getToken();

    // Navigate based on token existence
    if (token != null && token.isNotEmpty) {
      Get.offAll(() => const PrimaryScreen()); // Navigate to HomeScreen if token exists
    } else {
      Get.offAll(
          () => const LoginScreen()); // Navigate to LoginScreen if no token
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: Center(
          child: Text(
            AppConfig.appName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
    );
  }
}
