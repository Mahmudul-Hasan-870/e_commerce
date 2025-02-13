import 'package:e_commerce/models/product_model.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var productList = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Fetch products from the API
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true; // Set loading to true when starting the fetch
      final response = await http.get(Uri.parse(AppConfig.productsUrl));
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          final List<dynamic> data = jsonData['data'];
          // Parse the product data and update the observable productList
          productList.value = data.map((product) => ProductModel.fromJson(product)).toList();
        } else {
          Get.snackbar('Error', 'Failed to fetch products: Invalid response format');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching products: ${e.toString()}');
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false; // Set loading to false when finished
    }
  }
}
