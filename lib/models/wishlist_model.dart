import 'package:hive/hive.dart';

part 'wishlist_model.g.dart'; // You need to generate this file using build_runner.

@HiveType(typeId: 4)
class WishlistModel extends HiveObject {
  @HiveField(0)
  String productName;

  @HiveField(1)
  String productImage;

  @HiveField(2)
  String productPrice;

  WishlistModel({
    required this.productName,
    required this.productImage,
    required this.productPrice,
  });
}
