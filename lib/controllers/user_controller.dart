import 'dart:convert';

import 'package:e_commerce/controllers/local_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/order_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var user = User(name: '', email: '').obs;
  var orders = <Order>[].obs; // Observable list of orders
  final SharedPreferencesController _prefsController =
      SharedPreferencesController();

  // Fetch user data from API
  Future<void> fetchUserData() async {
    try {
      final token = await _prefsController.getToken();
      if (token == null) {
        return;
      }

      final response = await http.get(
        Uri.parse(AppConfig.meUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          user.value = User.fromJson(jsonResponse['data']);
        } else {
          Get.snackbar(
              'Error', jsonResponse['message'] ?? 'Failed to load user data');
        }
      } else {
        Get.snackbar('Error', 'Failed to load user data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }

  // Fetch orders for the authenticated user
  Future<void> fetchOrders() async {
    try {
      final token = await _prefsController.getToken();
      if (token == null) {
        return;
      }

      final response = await http.get(
        Uri.parse(AppConfig.ordersUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          orders.value = (jsonResponse['orders'] as List)
              .map((orderJson) => Order.fromJson(orderJson))
              .toList();
        } else {
          Get.snackbar(
              'Error', jsonResponse['message'] ?? 'Failed to load orders');
        }
      } else {
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }
}
