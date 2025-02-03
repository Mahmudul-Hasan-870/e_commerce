import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../controllers/forgot_password_controller.dart';
import '../../../utils/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController _forgotPasswordController =
      Get.put(ForgotPasswordController());

  final TextEditingController emailController = TextEditingController();

  void sendOtp() {
    if (emailController.text.isEmpty) {
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        description: Text(
          'All fields are required!',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    } else {
      _forgotPasswordController.sendOtp(context, emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your email to receive OTP for password reset',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(.5),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  IconlyLight.message,
                  color: AppColors.primaryColor,
                ),
                hintText: 'Email',
                hintStyle: GoogleFonts.poppins(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * .9,
              height: 50,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: sendOtp,
                    child: _forgotPasswordController.isLoading.value
                        ? Text(
                            'Sending OTP...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            'Send OTP',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
