import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../order_history.dart';


class ProfilePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    // Fetch user data when the widget is built
    userController.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Back button and profile title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.black),
                  SizedBox(width: 16),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Profile picture, name, and status
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage("https://robohash.org/stefan-one"),
            ),
            SizedBox(height: 16),
            Obx(() => Text(
              userController.user.value.name.isNotEmpty
                  ? userController.user.value.name
                  : 'Loading...',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(width: 4),
                Text(
                  'Active status',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Menu items
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    buildMenuItem(Icons.person, 'Edit Profile'),
                    buildMenuItem(Icons.location_on, 'Shopping Address'),
                    buildMenuItem(Icons.favorite, 'Wishlist'),
                    buildMenuItem(Icons.history, 'Order History', () {
                      Get.to(OrdersPage()); // Navigate to OrderHistoryPage
                    }),
                    buildMenuItem(Icons.notifications, 'Notification'),
                    buildMenuItem(Icons.credit_card, 'Cards'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for menu items
  Widget buildMenuItem(IconData icon, String text, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
      onTap: onTap ?? () {
        // Default action if no onTap provided
      },
    );
  }
}
