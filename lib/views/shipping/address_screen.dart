import 'package:e_commerce/utils/colors.dart';
import 'package:e_commerce/views/shipping/shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../controllers/shipping_controller.dart';
import '../payment/stripe.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ShippingController shippingController = Get.find();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          "Address",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: () {
                // Navigate to ShippingAddressScreen with empty data for adding new address
                Get.to(() => ShippingAddressScreen());
              },
              child: Text(
                '+ Add New',
                style: GoogleFonts.poppins(
                  color: Colors.teal,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            IconlyLight.arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ADDRESS",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // Address List with Dismissible
              SizedBox(
                height: size.height * 0.3,
                child: Obx(() {
                  if (shippingController.addresses.isEmpty) {
                    return Center(
                        child: Text(
                      "No addresses available",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: shippingController.addresses.length,
                    itemBuilder: (context, index) {
                      final address = shippingController.addresses[index];

                      return Dismissible(
                        key: Key(address.toString()),
                        // Unique key
                        direction: DismissDirection.endToStart,
                        // Swipe right to left
                        onDismissed: (direction) {
                          shippingController.removeAddress(index);
                          // Ensure the widget is removed from the list after dismissal
                          shippingController.addresses.removeAt(index);
                          Get.snackbar('Address Deleted',
                              'The address has been removed.');
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            IconlyBold.delete,
                            color: Colors.white,
                            size: 24, // Optional: Adjust size as needed
                          ),
                        ),

                        child: GestureDetector(
                          onTap: () {
                            shippingController.selectAddress(index);
                          },
                          child: Obx(() {
                            bool isSelected =
                                shippingController.selectedAddressIndex.value ==
                                    index;
                            return addressCard(
                              address.shippingTo,
                              "${address.address}, ${address.city}, ${address.state}, ${address.postalCode}, ${address.country}",
                              isSelected,
                              () {
                                Get.to(() => ShippingAddressScreen(
                                      shippingAddress: address,
                                    ));
                              },
                            );
                          }),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Delivery Estimate Section
              Text(
                "DELIVERY ESTIMATE",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    shippingController.selectDeliveryOption(0);
                  },
                  child: deliveryOptionCard(
                    Icons.local_shipping,
                    "Standard Delivery",
                    "Same Day",
                    shippingController.selectedDeliveryOptionIndex.value == 0,
                  ),
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    shippingController.selectDeliveryOption(1);
                  },
                  child: deliveryOptionCard(
                    Icons.local_shipping_outlined,
                    "Instant Delivery",
                    "30-40 Min",
                    shippingController.selectedDeliveryOptionIndex.value == 1,
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Next Button
              // Next Button
              SizedBox(
                width: size.width * .9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (shippingController.selectedAddressIndex.value == -1) {
                      Get.snackbar('No Address Selected', 'Please select a delivery address.');
                    } else if (shippingController.selectedDeliveryOptionIndex.value == -1) {
                      Get.snackbar('No Delivery Option Selected', 'Please select a delivery option.');
                    } else {
                      // If both address and delivery option are selected, navigate to Stripe Payment Page
                      Get.to(() => const StripePaymentPage());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    'Next',
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
      ),
    );
  }

  // Address Card Widget
  Widget addressCard(
      String title, String address, bool isSelected, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                backgroundColor: Colors.grey.shade200,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delivery Option Card Widget
  Widget deliveryOptionCard(
      IconData iconData, String title, String time, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 28,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
