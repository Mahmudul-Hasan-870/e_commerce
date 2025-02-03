import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/shipping_address_model.dart';

class ShippingController extends GetxController {
  // TextEditingControllers for handling input fields in the form
  var shippingToController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var countryController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneNumberController = TextEditingController();

  // Hive box for storing and retrieving shipping address data
  Box? shippingBox;

  // Observable list to keep track of addresses and their states
  RxList<ShippingAddressModel> addresses = <ShippingAddressModel>[].obs;

  // To track the index of the item being edited
  var editingIndex = Rxn<int>();

  // To track the selected address and delivery option
  RxInt selectedAddressIndex = RxInt(-1);
  RxInt selectedDeliveryOptionIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    _initHiveBox(); // Initialize Hive box when the controller is created
  }

  // Open Hive box and load existing shipping data
  Future<void> _initHiveBox() async {
    shippingBox = await Hive.openBox('shippingAddresses');
    loadShippingData();
  }

  @override
  void onClose() {
    // Dispose of TextEditingControllers to free up resources
    shippingToController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    countryController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  // Load shipping data from Hive into the observable list
  void loadShippingData() {
    if (shippingBox != null) {
      addresses.clear();
      for (int i = 0; i < shippingBox!.length; i++) {
        final savedData = shippingBox!.getAt(i) as ShippingAddressModel;
        addresses.add(savedData);
      }
    }
  }

  // Set the data to be edited into the form fields
  void setEditingData(ShippingAddressModel address, int index) {
    shippingToController.text = address.shippingTo;
    firstNameController.text = address.firstName;
    lastNameController.text = address.lastName;
    countryController.text = address.country;
    addressController.text = address.address;
    cityController.text = address.city;
    stateController.text = address.state;
    postalCodeController.text = address.postalCode;
    phoneNumberController.text = address.phoneNumber;
    editingIndex.value = index;
  }

  // Save or update shipping address in Hive
  void saveShippingData() {
    if (shippingBox == null) {
      Get.snackbar("Error", "Shipping box not initialized.");
      return;
    }

    final shippingAddress = ShippingAddressModel(
      shippingTo: shippingToController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      country: countryController.text,
      address: addressController.text,
      city: cityController.text,
      state: stateController.text,
      postalCode: postalCodeController.text,
      phoneNumber: phoneNumberController.text,
    );

    if (editingIndex.value != null) {
      // Update existing address
      shippingBox!.putAt(editingIndex.value!, shippingAddress);
      addresses[editingIndex.value!] = shippingAddress;
    } else {
      // Add new address
      shippingBox!.add(shippingAddress);
      addresses.add(shippingAddress);
    }

    Get.snackbar("Success", "Shipping address saved!");
  }

  // Select an address from the list
  void selectAddress(int index) {
    selectedAddressIndex.value = index;
  }

  // Select a delivery option
  void selectDeliveryOption(int index) {
    selectedDeliveryOptionIndex.value = index;
  }

  // Remove an address from Hive and observable list
  void removeAddress(int index) {
    if (shippingBox != null) {
      shippingBox!.deleteAt(index);
      addresses.removeAt(index);
    }
  }
}
