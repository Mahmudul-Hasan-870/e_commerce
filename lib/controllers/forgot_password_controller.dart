import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';
import '../views/auth/password/reset_password.dart';

class ForgotPasswordController extends GetxController {
  late TextEditingController emailController;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  void clearController() {
    emailController.clear();
  }

  Future<void> sendResetLink() async {
    try {
      if (emailController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your email',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      isLoading.value = true;

      final response = await http.post(
        Uri.parse(AppConfig.forgotPasswordUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text.trim(),
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          clearController();
          Get.snackbar(
            'Success',
            'Password reset link sent to your email',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
          );
          await Future.delayed(const Duration(seconds: 1));
          Get.to(() => const ResetPasswordScreen());
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? 'Failed to send reset link',
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
    emailController.dispose();
    super.onClose();
  }
}
