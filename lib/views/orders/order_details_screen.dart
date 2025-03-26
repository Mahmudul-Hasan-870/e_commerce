import 'package:flutter/material.dart';

import '../../models/order_model.dart'; // Import your Order model

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Order ID
            Text(
              'Order ID: ${order.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Total Amount
            _buildDetailRow(
                'Total Amount:', '\$${order.totalAmount.toStringAsFixed(2)}'),
            _buildDetailRow('Order Status:', _capitalize(order.orderStatus)),
            _buildDetailRow(
                'Payment Status:', _capitalize(order.paymentStatus)),
            const SizedBox(height: 16),

            // Delivery Address
            const Text(
              'Delivery Address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  order.deliveryAddress,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Option
            _buildDetailRow(
                'Delivery Option:', _capitalize(order.deliveryOption)),
            const SizedBox(height: 16),

            // Items
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Prevent scrolling
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                      '${item.name} (x${item.quantity}) - \$${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a detail row
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Function to capitalize the first letter of a string
  String _capitalize(String s) {
    if (s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1);
  }
}
