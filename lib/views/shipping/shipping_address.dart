import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/shipping_controller.dart';
import '../../models/shipping_address_model.dart';
import '../../utils/colors.dart';
import '../../widgets/shippingTextField.dart';

class ShippingAddressScreen extends StatelessWidget {
  final ShippingController controller = Get.put(ShippingController());

  final ShippingAddressModel? shippingAddress;

  ShippingAddressScreen({Key? key, this.shippingAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Populate fields with existing data if available
    if (shippingAddress != null) {
      controller.shippingToController.text = shippingAddress!.shippingTo;
      controller.firstNameController.text = shippingAddress!.firstName;
      controller.lastNameController.text = shippingAddress!.lastName;
      controller.countryController.text = shippingAddress!.country;
      controller.addressController.text = shippingAddress!.address;
      controller.cityController.text = shippingAddress!.city;
      controller.stateController.text = shippingAddress!.state;
      controller.postalCodeController.text = shippingAddress!.postalCode;
      controller.phoneNumberController.text = shippingAddress!.phoneNumber;
      controller.editingIndex.value =
          Get.find<ShippingController>().addresses.indexOf(shippingAddress!);
    } else {
      // Clear fields if adding new address
      controller.shippingToController.clear();
      controller.firstNameController.clear();
      controller.lastNameController.clear();
      controller.countryController.clear();
      controller.addressController.clear();
      controller.cityController.clear();
      controller.stateController.clear();
      controller.postalCodeController.clear();
      controller.phoneNumberController.clear();
      controller.editingIndex.value = null; // Ensure no index is set
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Text(
          shippingAddress == null
              ? 'Shipping Address'
              : 'Edit Shipping Address',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            IconlyLight.arrow_left,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            shippingTextField('Shipping to', controller.shippingToController),
            const SizedBox(height: 16),
            shippingTextField('First Name', controller.firstNameController),
            const SizedBox(height: 16),
            shippingTextField('Last Name', controller.lastNameController),
            const SizedBox(height: 16),
            shippingTextField('Country', controller.countryController),
            const SizedBox(height: 16),
            shippingTextField('Address', controller.addressController),
            const SizedBox(height: 16),
            shippingTextField('City', controller.cityController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: shippingTextField(
                      'State/Region', controller.stateController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: shippingTextField(
                      'Postal Code', controller.postalCodeController),
                ),
              ],
            ),
            const SizedBox(height: 16),
            shippingTextField('Phone Number', controller.phoneNumberController),
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * .9,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.saveShippingData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text(
                  shippingAddress == null ? 'Save' : 'Update',
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
      ),
    );
  }
}
