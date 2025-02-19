import 'package:e_commerce/controllers/payment_controller.dart';
import 'package:e_commerce/models/shipping_address_model.dart';
import 'package:e_commerce/utils/config.dart';
import 'package:e_commerce/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import 'controllers/cart_controller.dart';
import 'controllers/shipping_controller.dart';
import 'models/cart_model.dart';
import 'models/wishlist_model.dart';

void main() async {
  await _setup();
  await Hive.initFlutter();
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(ShippingAddressModelAdapter());
  Hive.registerAdapter(WishlistModelAdapter());
  await Hive.openBox<WishlistModel>('wishlistBox');
  await Hive.openBox<CartModel>('cartBox');
  await Hive.openBox('shippingAddresses');
  Get.put(CartController()); // Register CartController
  Get.put(ShippingController()); // Initialize ShippingController
  Get.put(PaymentController()); // Initialize ShippingController
  runApp(const MyApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppConfig.stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(useMaterial3: true, scaffoldBackgroundColor: Colors.white),
      home: const SplashScreen(),
    );
  }
}
