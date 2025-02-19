import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <CartModel>[].obs;
  late Box<CartModel> cartBox;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromHive();
  }

  Future<void> loadCartFromHive() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      cartItems.clear(); // Clear existing items first
      cartBox = Hive.box<CartModel>('cartBox');
      cartItems.addAll(cartBox.values.toList());
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(CartModel item) async {
    try {
      final existingItemIndex = cartItems.indexWhere((cartItem) =>
          cartItem.title == item.title &&
          cartItem.size == item.size &&
          cartItem.price == item.price &&
          cartItem.color == item.color);

      if (existingItemIndex != -1) {
        cartItems[existingItemIndex].quantity += item.quantity;
        cartItems.refresh();
        await cartBox.clear();
        await cartBox.addAll(cartItems);
      } else {
        cartItems.add(item);
        await cartBox.clear();
        await cartBox.addAll(cartItems);
      }
    } catch (e) {
      hasError.value = true;
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      if (index >= 0 && index < cartItems.length) {
        cartItems.removeAt(index);
        await cartBox.clear();
        await cartBox.addAll(cartItems);
      }
    } catch (e) {
      hasError.value = true;
    }
  }

  Future<void> increaseQuantity(int index) async {
    try {
      if (index >= 0 && index < cartItems.length) {
        cartItems[index].quantity++;
        cartItems.refresh();
        await cartBox.clear();
        await cartBox.addAll(cartItems);
      }
    } catch (e) {
      hasError.value = true;
    }
  }

  Future<void> decreaseQuantity(int index) async {
    try {
      if (index >= 0 && index < cartItems.length) {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity--;
          cartItems.refresh();
          await cartBox.clear();
          await cartBox.addAll(cartItems);
        }
      }
    } catch (e) {
      hasError.value = true;
    }
  }

  Future<void> clearCart() async {
    try {
      await cartBox.clear();
      cartItems.clear();
    } catch (e) {
      hasError.value = true;
      print('Error clearing cart: $e');
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += double.parse(item.price) * item.quantity;
    }
    return total;
  }

  List<CartModel> getCartItems() {
    return cartItems.toList();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Your fetch logic here
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
