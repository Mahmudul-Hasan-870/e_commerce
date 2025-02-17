import 'dart:convert';

import 'package:e_commerce/controllers/prefs_controller.dart';
import 'package:e_commerce/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

import '../utils/config.dart';
import '../widgets/primary_screen.dart';

class LoginController extends GetxService {
  // Dependencies
  final SharedPreferencesController _prefsController = SharedPreferencesController();

  // Text Controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Observable States
  final RxBool isLoading = false.obs;
  final RxBool isObscure = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
  }

  // Initialize text controllers
  void initializeControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // Toggle password visibility
  void togglePasswordVisibility() => isObscure.value = !isObscure.value;

  // Clear text fields
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // Validate input fields
  bool _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar('Please fill in all fields');
      return false;
    }
    return true;
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }

  // Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
    );
  }

  // Login method
  Future<void> login(BuildContext context) async {
    try {
      if (!_validateInputs()) return;
      
      isLoading.value = true;

      final response = await _performLoginRequest();
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        await _handleSuccessfulLogin(data);
      } else {
        _showErrorSnackbar(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  // Perform login API request
  Future<http.Response> _performLoginRequest() async {
    return await http.post(
      Uri.parse(AppConfig.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text.trim(),
        'password': passwordController.text,
      }),
    );
  }

  // Handle successful login
  Future<void> _handleSuccessfulLogin(Map<String, dynamic> data) async {
    await _prefsController.saveToken(data['token']);
    clearControllers();
    _showSuccessSnackbar('Login successful');
    Get.offAll(() => const PrimaryScreen());
  }
}
