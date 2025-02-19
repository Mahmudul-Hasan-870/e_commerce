import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import 'order_details_section.dart';
import 'order_stepper.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;
  final bool isProcessed;

  const OrderCard({
    super.key,
    required this.order,
    required this.isProcessed,
  });

  @override
  Widget build(BuildContext context) {
    int statusLevel = 0;
    if (order.orderStatus == 'success') {
      statusLevel = 3;
    } else if (order.orderStatus == 'pending') {
      statusLevel = 2;
    } else if (order.orderStatus == 'cash_on_delivery') {
      statusLevel = 1;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header
          _buildOrderHeader(),

          // Order Stepper
          OrderStepper(statusLevel: statusLevel, order: order),

          // Order Details
          OrderDetailsSection(order: order),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id.substring(0, 8)}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(
                  DateTime.parse(order.createdAt),
                ),
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.orderStatus.toUpperCase(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
