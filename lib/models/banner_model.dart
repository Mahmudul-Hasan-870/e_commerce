import '../utils/config.dart';

class BannerModel {
  final String id;
  final String title;
  final String image;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Add a getter for the full image URL
  String get fullImageUrl => '${AppConfig.baseUrl}/uploads/banners/$image';
}
