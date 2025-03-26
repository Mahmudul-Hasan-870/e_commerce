import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../widgets/auth/login/login_buttons.dart';
import '../../../widgets/auth/login/login_form.dart';
import '../../../widgets/auth/login/login_header.dart';

class LoginScreen extends StatelessWidget {
  // Initialize controller as permanent to prevent disposal
  final loginController = Get.put(LoginController(), permanent: true);

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoginHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    LoginForm(controller: loginController),
                    const SizedBox(height: 20),
                    LoginButtons(controller: loginController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
