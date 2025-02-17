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

  void _showSnackbar({
    required String title,
    required String message,
    required bool isError,
  }) {
    Get.closeAllSnackbars();
    
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError 
          ? Colors.red[50]!.withOpacity(0.95) 
          : Colors.green[50]!.withOpacity(0.95),
      colorText: isError ? Colors.red[800] : Colors.green[800],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: isError ? Colors.red[800] : Colors.green[800],
        size: 28,
      ),
      shouldIconPulse: true,
      snackStyle: SnackStyle.FLOATING,
      overlayBlur: 0,
      overlayColor: Colors.black.withOpacity(0.05),
      boxShadows: [
        BoxShadow(
          color: (isError ? Colors.red : Colors.green).withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void saveShippingData() async {
    try {
      if (shippingBox == null) {
        _showSnackbar(
          title: "Error",
          message: "Shipping box not initialized.",
          isError: true,
        );
        return;
      }

      // Validate required fields
      if (!_validateFields()) {
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

      if (editingIndex.value != null && editingIndex.value! >= 0) {
        // Update existing address
        await shippingBox!.putAt(editingIndex.value!, shippingAddress);
        addresses[editingIndex.value!] = shippingAddress;
        
        // Show success message
        await Future.delayed(const Duration(milliseconds: 100));
        _showSnackbar(
          title: "Success",
          message: "Address updated successfully!",
          isError: false,
        );
      } else {
        // Add new address
        await shippingBox!.add(shippingAddress);
        addresses.add(shippingAddress);
        
        // Show success message
        await Future.delayed(const Duration(milliseconds: 100));
        _showSnackbar(
          title: "Success",
          message: "New address added successfully!",
          isError: false,
        );
      }

      // Wait for snackbar to show before navigating back
      await Future.delayed(const Duration(seconds: 1));
      Get.back();

    } catch (e, stackTrace) {
      print('Error saving address: $e');
      print('Stack trace: $stackTrace');
      
      // Show error message
      await Future.delayed(const Duration(milliseconds: 100));
      _showSnackbar(
        title: "Error",
        message: "Failed to save address. Please try again.",
        isError: true,
      );
    }
  }

  bool _validateFields() {
    if (shippingToController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        countryController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      _showSnackbar(
        title: "Error",
        message: "Please fill in all fields",
        isError: true,
      );
      return false;
    }
    return true;
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

  // Add this method to clear all text fields
  void clearFields() {
    shippingToController.clear();
    firstNameController.clear();
    lastNameController.clear();
    countryController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
    phoneNumberController.clear();
    editingIndex.value = -1; // Reset editing index
  }
}
