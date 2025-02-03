import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <CartModel>[].obs;
  late Box<CartModel> cartBox;

  @override
  void onInit() {
    super.onInit();
    loadCartFromHive(); // Load cart items from Hive when the controller is initialized
  }

  Future<void> loadCartFromHive() async {
    cartBox = Hive.box<CartModel>('cartBox');
    cartItems.addAll(cartBox.values.toList()); // Load all items from Hive
  }

  Future<void> addToCart(CartModel item) async {
    final existingItemIndex = cartItems.indexWhere((cartItem) =>
    cartItem.title == item.title &&
        cartItem.size == item.size &&
        cartItem.price == item.price);

    if (existingItemIndex != -1) {
      // Update existing item quantity
      cartItems[existingItemIndex].quantity += item.quantity;
      cartItems.refresh(); // Notify listeners about the change
      await cartBox.putAt(existingItemIndex, cartItems[existingItemIndex]); // Update the item in Hive
    } else {
      // Add new item to cartItems and Hive
      cartItems.add(item);
      await cartBox.add(item); // Add the item to Hive
    }
  }

  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < cartItems.length) {
      await cartBox.deleteAt(index); // Remove the item from Hive
      cartItems.removeAt(index);
    }
  }

  Future<void> clearCart() async {
    await cartBox.clear(); // Clear all items from Hive
    cartItems.clear(); // Clear the list of items in memory
  }

  Future<void> increaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index].quantity++;
      cartItems.refresh(); // Notify listeners about the change
      await cartBox.putAt(index, cartItems[index]); // Update the quantity in Hive
    }
  }

  Future<void> decreaseQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh(); // Notify listeners about the change
        await cartBox.putAt(index, cartItems[index]); // Update the quantity in Hive
      }
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
}
