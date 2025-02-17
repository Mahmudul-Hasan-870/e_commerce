import 'dart:convert';
import 'package:e_commerce/views/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

import '../utils/config.dart';

class ResetPasswordController extends GetxController {
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  var isLoading = false.obs;
  var isObscure = true.obs;

  @override
  void onInit() {
    super.onInit();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  void clearControllers() {
    otpController.clear();
    newPasswordController.clear();
  }

  /// Send Reset Password Link
  Future<void> resetPassword() async {
    try {
      if (otpController.text.isEmpty || newPasswordController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      isLoading.value = true;

      // Print request details for debugging
      print('Request URL: ${AppConfig.resetPasswordUrl}');
      print('Request Body: ${json.encode({
        'otp': otpController.text.trim(),
        'password': newPasswordController.text, // Changed from new_password to password
      })}');

      final response = await http.post(
        Uri.parse(AppConfig.resetPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'otp': otpController.text.trim(),
          'password': newPasswordController.text, // Changed from new_password to password
        }),
      );

      // Print response for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          clearControllers();
          Get.snackbar(
            'Success',
            'Password reset successful',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
          );
          await Future.delayed(const Duration(seconds: 1));
          Get.offAll(() => LoginScreen());
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? 'Password reset failed',
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
        }
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to connect to server',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    } catch (e) {
      print('Error: $e'); // Add error logging
      Get.snackbar(
        'Error',
        'An error occurred',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
