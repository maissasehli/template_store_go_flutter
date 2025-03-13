class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api/mobile-app';
  static const String storeId = 'e791d82d-6448-441d-81c3-193b77a2b304';

  // Auth
  static const String login = '$baseUrl/auth/sign-in';
  static const String register = '$baseUrl/auth/sign-up';
  static const String logout = '$baseUrl/auth/sign-out';

  // Categories
  static const String getCategories = '$baseUrl/categories';
}

