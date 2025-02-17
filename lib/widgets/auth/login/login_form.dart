import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../../../controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;

  const LoginForm({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: controller.emailController,
      decoration: _buildInputDecoration(
        hintText: 'Email',
        prefixIcon: const Icon(IconlyLight.message, color: Colors.grey),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextField(
        controller: controller.passwordController,
        obscureText: controller.isObscure.value,
        decoration: _buildInputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(IconlyLight.lock, color: Colors.grey),
          suffixIcon: _buildPasswordToggleIcon(),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey,
        fontSize: 14,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  Widget _buildPasswordToggleIcon() {
    return IconButton(
      onPressed: controller.togglePasswordVisibility,
      icon: Icon(
        controller.isObscure.value ? IconlyLight.hide : IconlyLight.show,
        color: Colors.grey,
      ),
    );
  }
} 