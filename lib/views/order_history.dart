import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'order_details_page.dart'; // Import the order details page

class OrdersPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userController.fetchOrders(); // Fetch orders when the page is built

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Obx(() {
        // Check if orders are empty
        if (userController.orders.isEmpty) {
          return Center(child: Text('No Items'));
        }

        return ListView.builder(
          itemCount: userController.orders.length,
          itemBuilder: (context, index) {
            final order = userController.orders[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                    Text('Status: ${capitalize(order.orderStatus)}'), // Capitalize the first letter
                    SizedBox(height: 8),
                    Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...order.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${item.name} (x${item.quantity}) - \$${item.price.toStringAsFixed(2)}',
                        ),
                      );
                    }).toList(),
                  ],
                ),
                onTap: () {
                  // Navigate to the order details page
                  Get.to(() => OrderDetailsPage(order: order));
                },
              ),
            );
          },
        );
      }),
    );
  }

  // Function to capitalize the first letter of a string
  String capitalize(String s) {
    if (s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }
}
