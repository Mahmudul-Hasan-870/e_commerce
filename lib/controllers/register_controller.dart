import 'dart:convert';

import 'package:e_commerce/controllers/local_controller.dart';
import 'package:e_commerce/views/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/config.dart';

class RegisterController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Observable variables
  var isLoading = false.obs;
  var isObscure = true.obs;

  final SharedPreferencesController _prefsController =
      SharedPreferencesController();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      // Validate input fields
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all fields',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      final response = await http.post(
        Uri.parse(AppConfig.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['status'] == 'success') {
          clearControllers(); // Clear the text fields
          // Remove token saving
          // await _prefsController.saveToken(data['token']);

          Get.snackbar(
            'Success',
            'Registration successful',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
          );
          await Future.delayed(const Duration(seconds: 1));
          // Navigate to LoginScreen instead of PrimaryScreen
          Get.offAll(() => LoginScreen());
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? 'Registration failed',
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
    // Dispose controllers in onClose instead of dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
