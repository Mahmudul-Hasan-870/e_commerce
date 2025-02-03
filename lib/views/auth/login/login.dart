import 'package:e_commerce/controllers/login_controller.dart';
import 'package:e_commerce/views/auth/password/forgot_password.dart';
import 'package:e_commerce/views/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void signin() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        description: Text(
          'All fields are required!',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    } else {
      _loginController.login(
        context,
        emailController.text,
        passwordController.text,
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
                    'Login',
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
                    'Login to continue using the app',
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconlyLight.lock,
                      color: AppColors.primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? IconlyLight.show : IconlyLight.hide,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Password',
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
                  obscureText: _obscureText,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width * .9,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    onPressed: signin,
                    child: _loginController.isLoading.value
                        ? Text(
                            'Logging in...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: .5),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(.5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: .5),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const RegisterScreen());
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5),
                        ))
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
