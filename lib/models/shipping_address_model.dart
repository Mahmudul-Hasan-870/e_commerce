import 'package:hive/hive.dart';

part 'shipping_address_model.g.dart';

@HiveType(typeId: 2)
class ShippingAddressModel {
  @HiveField(0)
  final String shippingTo;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String country;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String state;

  @HiveField(7)
  final String postalCode;

  @HiveField(8)
  final String phoneNumber;

  ShippingAddressModel({
    required this.shippingTo,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'shippingTo': shippingTo,
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
    };
  }
}
