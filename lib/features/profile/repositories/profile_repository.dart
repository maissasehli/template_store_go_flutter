import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/profile/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ProfileRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final logger = Logger();

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Get current user's ID
  Future<String> getCurrentUserId() async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) {
      throw Exception('User ID not found in storage');
    }
    return userId;
  }

  // Get user by ID
  Future<UserModel> getUserById(String id) async {
    try {
      logger.d("Getting user by ID: $id");
      final response = await _apiClient.get(
        "/users/$id",
      ); // Updated API endpoint

      if (response.statusCode == 200) {
        logger.d("User data retrieved: ${response.data}");
        logger.d(
          "User avatar field in response: ${response.data['data']?['avatar']}",
        );
        final userModel = UserModel.fromJson(response.data['data']);
        logger.d("UserModel created with avatar: ${userModel.avatar}");
        return userModel;
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      logger.e("Error getting user by ID: $id, $e");
      rethrow;
    }
  }

  // Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      // Get the current user ID from secure storage
      final userId = await getCurrentUserId();
      logger.d("Getting current user with ID: $userId");
      return await getUserById(userId);
    } catch (e) {
      logger.e("Error getting current user: $e");
      rethrow;
    }
  }

  // Upload avatar
  Future<UserModel> uploadAvatar(File imageFile) async {
    try {
      final userId = await getCurrentUserId();
      logger.d("Uploading avatar for user: $userId");

      // Create form data
      final formData = await _createFormData(imageFile); // Send the request
      final response = await _apiClient.post(
        "/users/$userId/avatar", // Correct API endpoint
        data: formData,
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      logger.d("Avatar upload response: ${response.data}");

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to upload avatar');
      }
    } catch (e) {
      logger.e("Error uploading avatar: $e");
      rethrow;
    }
  }

  // Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
    try {
      final userId = await getCurrentUserId();
      logger.d("Updating profile for user: $userId");

      final response = await _apiClient.put(
        "/users/$userId",
        data: userData,
      ); // Correct API endpoint

      if (response.statusCode == 200) {
        logger.d("Profile updated successfully");
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      logger.e("Error updating profile: $e");
      rethrow;
    }
  }

  // Helper method to create form data
  Future<dio.FormData> _createFormData(File imageFile) async {
    return dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(
        // Updated field name from 'avatar' to 'image'
        imageFile.path,
        filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.png',
        contentType: MediaType('image', 'png'),
      ),
    });
  }

  // Delete user avatar
  Future<UserModel> deleteAvatar() async {
    try {
      final userId = await getCurrentUserId();
      logger.d("Deleting avatar for user: $userId");

      final response = await _apiClient.delete("/users/$userId/avatar");

      if (response.statusCode == 200) {
        logger.d("Avatar deleted successfully");
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to delete avatar');
      }
    } catch (e) {
      logger.e("Error deleting avatar: $e");
      rethrow;
    }
  }

  // Update user status
  Future<void> updateUserStatus(bool isOnline) async {
    try {
      final userId = await getCurrentUserId();
      logger.d("Updating user status for user: $userId, isOnline: $isOnline");
      final response = await _apiClient.post(
        "/users/status",
        data: {
          'user_id': userId,
          'is_online': isOnline,
          'last_seen': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      logger.e("Error updating user status: $e");
      rethrow;
    }
  }
}
