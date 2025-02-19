import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/forgot_password_controller.dart';
import '../../../widgets/auth/password/forgot_password_button.dart';
import '../../../widgets/auth/password/forgot_password_form.dart';
import '../../../widgets/auth/password/forgot_password_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key}) {
    Get.put(ForgotPasswordController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ForgotPasswordHeader(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    ForgotPasswordForm(controller: controller),
                    ForgotPasswordButton(controller: controller),
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
