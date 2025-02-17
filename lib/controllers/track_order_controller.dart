import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/track_order_model.dart';
import '../utils/config.dart';
import 'prefs_controller.dart';

class TrackOrderController extends GetxController {
  final SharedPreferencesController prefsController = SharedPreferencesController();
  RxList<TrackOrderModel> orders = <TrackOrderModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final token = await prefsController.getToken();
      
      if (token == null) {
        Get.snackbar('Error', 'Please login to view orders');
        return;
      }

      final response = await http.get(
        Uri.parse(AppConfig.ordersUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> ordersJson = responseData['data'];
          
          List<TrackOrderModel> ordersList = ordersJson
              .map((json) => TrackOrderModel.fromJson(json))
              .toList();
          
          ordersList.sort((a, b) => 
            DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt))
          );
          
          orders.value = ordersList;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
} 