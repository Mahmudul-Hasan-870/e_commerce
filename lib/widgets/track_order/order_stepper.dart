import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';

class OrderStepper extends StatelessWidget {
  final int statusLevel;
  final dynamic order;

  const OrderStepper({
    super.key,
    required this.statusLevel,
    required this.order,
  });

  Widget _buildStepperDot(bool isActive, bool isCompleted) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.primaryColor
            : isActive
                ? Colors.white
                : Colors.grey[300],
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : isActive
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepperDot(true, true),
              Expanded(
                child: Container(
                  height: 2,
                  color: statusLevel >= 2
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                ),
              ),
              _buildStepperDot(statusLevel >= 2, statusLevel >= 2),
              Expanded(
                child: Container(
                  height: 2,
                  color: statusLevel >= 3
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                ),
              ),
              _buildStepperDot(statusLevel >= 3, statusLevel >= 3),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Placed',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Processing',
                style: GoogleFonts.poppins(
                  color: statusLevel >= 2 ? Colors.black : Colors.grey,
                  fontWeight:
                      statusLevel >= 2 ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              Text(
                'Completed',
                style: GoogleFonts.poppins(
                  color: statusLevel >= 3 ? Colors.black : Colors.grey,
                  fontWeight:
                      statusLevel >= 3 ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (statusLevel >= 3) ...[
            const SizedBox(height: 8),
            Text(
              'Completed on ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(order.createdAt))}',
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
