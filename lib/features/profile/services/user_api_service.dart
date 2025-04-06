import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserApiService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final logger = Logger();

  // Dependency injection through constructor
  UserApiService(this._apiClient);

  // Get user by ID method
  Future<dio.Response> getUserById(String id) async {
    try {
      logger.d("Getting user by ID: $id");
      final user = await _apiClient.get("/users/$id");
      logger.d("User data retrieved: ${user.data}");
      return user;
    } catch (e) {
      logger.e("Error getting user by ID: $id, $e");
      rethrow;
    }
  }

  // Get current user method (uses stored user ID)
  Future<dio.Response> getCurrentUser() async {
    try {
      // Get the current user ID from secure storage
      final userId = await _secureStorage.read(key: 'user_id');

      if (userId == null) {
        throw Exception('User ID not found in storage');
      }

      logger.d("Getting current user with ID: $userId");
      return await getUserById(userId);
    } catch (e) {
      logger.e("Error getting current user: $e");
      rethrow;
    }
  }
}
