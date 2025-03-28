import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/register_controller.dart';
import '../../../widgets/auth/register/register_buttons.dart';
import '../../../widgets/auth/register/register_form.dart';
import '../../../widgets/auth/register/register_header.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key}) {
    Get.put(RegisterController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const RegisterHeader(),
            RegisterForm(controller: controller),
            RegisterButtons(controller: controller),
          ],
        ),
      ),
    );
  }
}
