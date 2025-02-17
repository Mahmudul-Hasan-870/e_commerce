import 'package:flutter/material.dart';
import '../../controllers/shipping_controller.dart';
import 'shipping_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingFormFields extends StatelessWidget {
  final ShippingController controller;

  const ShippingFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Personal Information'),
        ShippingTextField(
          label: 'Shipping to',
          controller: controller.shippingToController,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ShippingTextField(
                label: 'First Name',
                controller: controller.firstNameController,
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ShippingTextField(
                label: 'Last Name',
                controller: controller.lastNameController,
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),
        _buildSectionTitle('Address Information'),
        ShippingTextField(
          label: 'Country',
          controller: controller.countryController,
          icon: Icons.public,
        ),
        const SizedBox(height: 16),
        ShippingTextField(
          label: 'Address',
          controller: controller.addressController,
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        ShippingTextField(
          label: 'City',
          controller: controller.cityController,
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ShippingTextField(
                label: 'State/Region',
                controller: controller.stateController,
                icon: Icons.map_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ShippingTextField(
                label: 'Postal Code',
                controller: controller.postalCodeController,
                icon: Icons.pin_drop_outlined,
              ),
            ),
          ],
        ),
        _buildSectionTitle('Contact Information'),
        ShippingTextField(
          label: 'Phone Number',
          controller: controller.phoneNumberController,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
} 