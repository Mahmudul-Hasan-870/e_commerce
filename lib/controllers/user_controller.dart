import 'package:e_commerce/controllers/prefs_controller.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/order_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var user = User(name: '', email: '').obs;
  var orders = <Order>[].obs; // Observable list of orders
  final SharedPreferencesController _prefsController = SharedPreferencesController();

  // Fetch user data from API
  Future<void> fetchUserData() async {
    try {
      final token = await _prefsController.getToken();
      if (token == null) {
        print('No token found');
        return;
      }

      final response = await http.get(
        Uri.parse(AppConfig.meUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          user.value = User.fromJson(jsonResponse['data']);
        } else {
          print('Failed to load user data: ${jsonResponse['message']}');
          Get.snackbar('Error', jsonResponse['message'] ?? 'Failed to load user data');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }

  // Fetch orders for the authenticated user
  Future<void> fetchOrders() async {
    try {
      final token = await _prefsController.getToken();
      if (token == null) {
        print('No token found');
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
          print('Failed to load orders: ${jsonResponse['message']}');
          Get.snackbar('Error', jsonResponse['message'] ?? 'Failed to load orders');
        }
      } else {
        print('Failed to load orders: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      Get.snackbar('Error', 'Failed to connect to server');
    }
  }
}
