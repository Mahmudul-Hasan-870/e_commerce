import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/wishlist_model.dart';

class WishlistController extends GetxController {
  final Box<WishlistModel> wishlistBox = Hive.box<WishlistModel>('wishlistBox');
  var wishlistItems = <WishlistModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;
      await Future.delayed(
          const Duration(milliseconds: 500)); // Optional: simulate loading
      wishlistItems.value = wishlistBox.values.toList();
    } finally {
      isLoading.value = false;
    }
  }

  // Add an item to the wishlist
  void addToWishlist(WishlistModel item) {
    wishlistBox.add(item);
    loadWishlist(); // Reload wishlist after adding
  }

  // Remove an item from the wishlist
  void removeFromWishlist(WishlistModel item) {
    item.delete(); // Delete from Hive
    loadWishlist(); // Reload wishlist after removal
  }

  // Check if an item is already in the wishlist
  bool isInWishlist(String productName) {
    return wishlistItems.any((item) => item.productName == productName);
  }
}
