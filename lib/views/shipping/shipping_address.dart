import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shipping_controller.dart';
import '../../models/shipping_address_model.dart';
import '../../widgets/shipping/shipping_app_bar.dart';
import '../../widgets/shipping/shipping_form_fields.dart';
import '../../widgets/shipping/shipping_save_button.dart';

class ShippingAddressScreen extends StatelessWidget {
  final ShippingController controller = Get.put(ShippingController());
  final ShippingAddressModel? shippingAddress;

  ShippingAddressScreen({Key? key, this.shippingAddress}) : super(key: key) {
    _initializeFields();
  }

  void _initializeFields() {
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
      controller.clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ShippingAppBar(isEditing: shippingAddress != null),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ShippingFormFields(controller: controller),
              ),
              ShippingSaveButton(
                controller: controller,
                isEditing: shippingAddress != null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
