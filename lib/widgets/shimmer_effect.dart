// Shimmer effect widget with rounded borders
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.79,
        ),
        itemCount: 6, // Show 6 placeholder items while loading
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners for all sides
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 20.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 100.0,
                      height: 20.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
