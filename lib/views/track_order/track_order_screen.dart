import 'package:e_commerce/views/home/home.dart';
import 'package:e_commerce/widgets/primary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../controllers/track_order_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/track_order/track_order_app_bar.dart';
import '../../widgets/track_order/order_card.dart';
import '../../widgets/track_order/empty_orders.dart';
import '../../widgets/shimmer_effect.dart';

class TrackOrderScreen extends StatelessWidget {
  final TrackOrderController controller = Get.put(TrackOrderController());

  TrackOrderScreen({Key? key}) : super(key: key);

  Future<void> _refreshOrders() async {
    await controller.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TrackOrderAppBar(),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshOrders,
          color: AppColors.primaryColor,
          child: Obx(() {
            if (controller.isLoading.value) {
              return buildTrackOrderShimmerEffect();
            }

            if (controller.orders.isEmpty) {
              return const EmptyOrders();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                bool isProcessed = order.orderStatus == 'processed';
                return OrderCard(
                  order: order,
                  isProcessed: isProcessed,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
