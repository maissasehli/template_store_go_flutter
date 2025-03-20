import 'package:dio/dio.dart';
import 'package:store_go/app/core/services/api_client.dart';

class UserApiService {
  final ApiClient _apiClient;

  // Dependency injection through constructor
  UserApiService(this._apiClient);

  // Update user profile method
  Future<Response> updateUserProfile({
    required String userId,
    String? gender,
    int? age,
    String? name,
    // Add other profile fields as needed
  }) async {
    // Filter out null values to only send fields that are being updated
    final Map<String, dynamic> updateData = {
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (name != null) 'name': name,
      // Add other fields as needed
    };

    // Only make the API call if we have data to update
    if (updateData.isEmpty) {
      throw Exception('No update data provided');
    }

    try {
      // Use your existing ApiClient for the PUT request
      return await _apiClient.put('/users/$userId', data: updateData);
    } catch (e) {
      // You can add specific error handling for user update operations
      rethrow;
    }
  }

  // Get user profile method
  Future<Response> getUserProfile(String userId) async {
    try {
      return await _apiClient.get('/users/$userId');
    } catch (e) {
      rethrow;
    }
  }
}
