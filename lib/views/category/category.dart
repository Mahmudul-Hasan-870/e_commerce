import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import 'category_detail.dart';

class CategoryScreen extends StatelessWidget {
  // Sample categories for the fashion store
  final List<String> categories = [
    "Men's Clothing",
    "Women's Clothing",
    "Accessories",
    "Shoes",
    "Bags",
    "Jewelry",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            IconlyLight.arrow_left,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0.0,
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10.0),
        itemCount: categories.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade100,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              categories[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              IconlyLight.arrow_right,
              color: Colors.black,
            ),
            onTap: () {
              // Navigate to category detail page
              Get.to(() => CategoryDetailScreen(categoryName: categories[index]));

            },
          );
        },
      ),
    );
  }
}

