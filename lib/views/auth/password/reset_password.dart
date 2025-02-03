import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../controllers/reset_password_controller.dart';
import '../../../utils/colors.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController _resetPasswordController =
  Get.put(ResetPasswordController());

  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void resetPassword() {
    if (otpController.text.isEmpty || newPasswordController.text.isEmpty) {
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        description: Text(
          'All fields are required!',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    } else {
      _resetPasswordController.resetPassword(
        context,
        otpController.text,
        newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/register.svg',
                  height: size.height * .4,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Reset Password',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enter OTP and new password',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconlyLight.password,
                      color: AppColors.primaryColor,
                    ),
                    hintText: 'OTP',
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: AppColors.primaryColor),
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
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconlyLight.lock,
                      color: AppColors.primaryColor,
                    ),
                    hintText: 'New Password',
                    hintStyle: GoogleFonts.poppins(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: AppColors.primaryColor),
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
                  obscureText: true,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width * .9,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    onPressed: resetPassword,
                    child: _resetPasswordController.isLoading.value
                        ? Text(
                      'Resetting Password...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                        : Text(
                      'Reset Password',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
