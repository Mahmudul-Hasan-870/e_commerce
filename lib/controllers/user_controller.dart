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
    final token = await _prefsController.getToken();
    final response = await http.get(
      Uri.parse(AppConfig.meUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      user.value = User.fromJson(jsonResponse['data']);
    } else {
      // Handle error
      print('Failed to load user data: ${response.statusCode}');
    }
  }

  // Fetch orders for the authenticated user
// user_controller.dart
  Future<void> fetchOrders() async {
    final token = await _prefsController.getToken();
    final response = await http.get(
      Uri.parse(AppConfig.ordersUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      orders.value = (jsonResponse['orders'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList();
    } else {
      // Handle error
      print('Failed to load orders: ${response.statusCode}');
    }
  }

}
