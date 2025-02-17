import 'package:e_commerce/utils/colors.dart';
import 'package:e_commerce/views/home/home.dart';
import 'package:e_commerce/views/track_order/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widgets/primary_screen.dart'; // For formatting the time

class OrderConfirmationScreen extends StatelessWidget {
  final String deliveryOption;

  const OrderConfirmationScreen({super.key, required this.deliveryOption});

  // Function to get the delivery date/time based on option
  String getDeliveryDateRange(String option) {
    DateTime now = DateTime.now();
    if (option == 'Standard') {
      // Set a time range for Standard delivery (e.g., 2 PM to 5 PM same day)
      DateTime standardStartTime = DateTime(now.year, now.month, now.day, 14); // 2 PM
      DateTime standardEndTime = DateTime(now.year, now.month, now.day, 17);   // 5 PM
      return 'Today, ${DateFormat('hh:mm a').format(standardStartTime)} - ${DateFormat('hh:mm a').format(standardEndTime)}';
    } else if (option == 'Express') {
      // Set 30 to 40 minutes from the current time for Express delivery
      DateTime expressStartTime = now.add(const Duration(minutes: 30));
      DateTime expressEndTime = now.add(const Duration(minutes: 40));
      return '${DateFormat('hh:mm a').format(expressStartTime)} - ${DateFormat('hh:mm a').format(expressEndTime)}';
    } else {
      return 'Unknown delivery time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Order Confirmed!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your order has been placed successfully.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                'Get delivery by ${getDeliveryDateRange(deliveryOption)}',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Track Order
                },
                child: Text(
                  'Track My Order',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.off(() => TrackOrderScreen());
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Track Order',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Have any questions? Reach directly to our',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to Customer Support
                },
                child: Text(
                  'Customer Support',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
