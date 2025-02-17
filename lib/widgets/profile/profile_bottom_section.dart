import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';

class ProfileBottomSection extends StatelessWidget {
  const ProfileBottomSection({Key? key}) : super(key: key);

  void showPrivacyPolicy() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Last updated: January 1, 2024',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information.',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 15),
              _buildSection(
                'Information We Collect',
                '• Personal information (name, email)\n• Device information\n• Usage data',
              ),
              _buildSection(
                'How We Use Your Information',
                '• To provide and improve our services\n• To communicate with you\n• To ensure security',
              ),
              _buildSection(
                'Data Protection',
                'We implement security measures to protect your personal information from unauthorized access or disclosure.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTermsOfService() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms of Service',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Last updated: January 1, 2024',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'By using our app, you agree to these terms of service.',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 15),
              _buildSection(
                'User Agreement',
                'You must be at least 13 years old to use this service. You are responsible for maintaining the security of your account.',
              ),
              _buildSection(
                'Acceptable Use',
                '• Do not violate any laws\n• Respect other users\n• Do not abuse the service',
              ),
              _buildSection(
                'Termination',
                'We reserve the right to terminate or suspend access to our service immediately, without prior notice.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Version 1.0.0',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
} 