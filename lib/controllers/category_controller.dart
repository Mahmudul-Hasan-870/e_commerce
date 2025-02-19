import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/prefs_controller.dart';
import '../utils/config.dart';

class CategoryController extends GetxController {
  var categories = <String>[].obs;
  var isLoading = true.obs;
  final SharedPreferencesController _prefsController =
      SharedPreferencesController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      // Get token from SharedPreferencesController
      final token = await _prefsController.getToken();

      if (token == null) {
        Get.snackbar('Error', 'Please login to view categories');
        return;
      }

      final response = await http.get(
        Uri.parse(AppConfig.categoriesUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          categories.value = List<String>.from(data['categories']);
        } else {
          Get.snackbar('Error', 'Failed to load categories');
        }
      } else {
        Get.snackbar('Error', 'Failed to connect to server');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching categories');
    } finally {
      isLoading.value = false;
    }
  }
}
