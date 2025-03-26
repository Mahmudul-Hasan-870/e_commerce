import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/reset_password_controller.dart';
import '../../../widgets/auth/password/reset_password_button.dart';
import '../../../widgets/auth/password/reset_password_form.dart';
import '../../../widgets/auth/password/reset_password_header.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ResetPasswordHeader(),
              ResetPasswordForm(controller: controller),
              ResetPasswordButton(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
