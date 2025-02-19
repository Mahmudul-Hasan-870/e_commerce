import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../views/category/category_detail.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;

  const CategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade100,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            categories[index],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            IconlyLight.arrow_right,
            color: Colors.black,
          ),
          onTap: () {
            Get.to(() => CategoryDetailScreen(categoryName: categories[index]));
          },
        );
      },
    );
  }
}
