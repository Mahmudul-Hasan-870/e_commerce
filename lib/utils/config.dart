class AppConfig {
  static const String appName = 'E-Commerce';

  static const String baseUrl = 'http://192.168.1.103:3000';
  static const String registerUrl = '$baseUrl/api/auth/register';
  static const String loginUrl = '$baseUrl/api/auth/login';
  static const String usersUrl = '$baseUrl/api/users';
  static const String meUrl = '$baseUrl/api/auth/profile';
  static const String ordersUrl = '$baseUrl/api/orders';
  static const String forgotPasswordUrl = '$baseUrl/api/auth/forgotPassword';
  static const String resetPasswordUrl = '$baseUrl/api/auth/resetPassword';
  static const String productsUrl = '$baseUrl/api/products';
  static const String productsOrdersUrl = '$baseUrl/api/order';
  static const String categoriesUrl = '$baseUrl/api/admin/categories/names';
  static const String bannersUrl = '$baseUrl/api/admin/active_banners';

  static const String razorpayTestKey = 'rzp_test_HJG5Rtuy8Xh2NB';

  static const String stripePublishableKey =
      "pk_test_51P9nVoRrokKxR1k7GYpiCd7B9ZVwmR7MBuYx28GmKrRsaOPUHmSMSIESH62ZVDwx6IFlN8xSz7br9cg0LzfLVbrK00uFBuBNzr";
  static const String stripeSecretKey =
      "sk_test_51P9nVoRrokKxR1k7ZI7p0s4EGGUxteZnJSrQBgYQAL6eJ8edEVjZU9ZClwoLjTB6cttxvH7cPj0HmbG7Ytv1y4Ye00ByP4fNQZ";
}
