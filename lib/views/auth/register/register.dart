import 'package:e_commerce/controllers/register_controller.dart';
import 'package:e_commerce/views/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterController _registerController = Get.put(RegisterController());

  bool _obscureText = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      MotionToast.error(
        toastDuration: const Duration(seconds: 5),
        description: Text(
          'All fields are required!',
          style: GoogleFonts.poppins(),
        ),
      ).show(context);
    } else {
      _registerController.register(
        context,
        nameController.text,
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/svg/register.svg',
                  height: size.height * .4,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Register',
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
                    'Enter your personal information',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      IconlyLight.profile,
                      color: AppColors.primaryColor,
                    ),
                    hintText: 'Name',
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
                const SizedBox(height: 20),
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
                    onPressed: register,
                    child: _registerController.isLoading.value
                        ? Text(
                            'Registering...',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            'Register',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(.5),
                          fontWeight: FontWeight.w600,
                          letterSpacing: .5),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const LoginScreen());
                        },
                        child: Text(
                          'Login',
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
