import 'dart:convert';

import 'package:e_commerce/controllers/prefs_controller.dart';
import 'package:e_commerce/views/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

import '../utils/config.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  final SharedPreferencesController _prefsController =
      SharedPreferencesController();

  Future<void> register(
      BuildContext context, String name, String email, String password) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppConfig.registerUrl),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Save token using SharedPreferencesController
        await _prefsController.saveToken(data['token']);

        MotionToast.success(
          toastDuration: const Duration(seconds: 5),
          description: Text(
            data['message'],
            style: GoogleFonts.poppins(),
          ),
        ).show(context);
        Get.offAll(() => const LoginScreen());
      } else {
        MotionToast.error(
          toastDuration: const Duration(seconds: 5),
          description: Text(
            data['message'] ?? 'An error occurred',
            style: GoogleFonts.poppins(),
          ),
        ).show(context);
      }
    } catch (e) {
      // Handle exceptions here
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        description: Text(
          'Please try again later',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    } finally {
      isLoading.value = false;
    }
  }
}
