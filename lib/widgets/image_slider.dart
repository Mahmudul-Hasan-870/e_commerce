import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildImageSlider(List<String> imageList) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 150.0,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.3,
      scrollDirection: Axis.horizontal,
    ),
    items: imageList.map((imageUrl) {
      return Builder(
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}
