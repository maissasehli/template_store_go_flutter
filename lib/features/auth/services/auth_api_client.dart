import 'package:dio/dio.dart';
import 'package:store_go/app/core/config/app_config.dart';
import 'package:store_go/app/core/services/api_client.dart';

/// API client specifically for authentication endpoints
class AuthApiClient {
  final ApiClient _apiClient = ApiClient();

  // Sign up
  Future<Response> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await _apiClient.post(
      '/auth/sign-up',
      data: {
        'email': email,
        'password': password,
        'name': '$firstName $lastName',
        'storeId': AppConfig.storeId,
      },
    );
  }

  // Sign in
  Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      '/auth/sign-in',
      data: {
        'email': email,
        'password': password,
        'storeId': AppConfig.storeId,
      },
    );
  }

  // Sign out
  Future<Response> signOut() async {
    return await _apiClient.post('/auth/sign-out');
  }

  // Initiate OAuth
  Future<Response> initiateOAuth({
    required String provider,
    required String redirectUrl,
  }) async {
    return await _apiClient.post(
      '/auth/oauth/initiate',
      data: {
        'provider': provider,
        'storeId': AppConfig.storeId,
        'redirectUrl': redirectUrl,
      },
    );
  }

  // Exchange authorization code for tokens
  Future<Response> exchangeAuthCode({required String code}) async {
    return await _apiClient.post(
      '/auth/oauth/callback',
      data: {'code': code, 'storeId': AppConfig.storeId},
    );
  }

  // Sign in with provider token
  Future<Response> signInWithProviderToken({
    required String provider,
    required String providerToken,
  }) async {
    return await _apiClient.post(
      '/auth/oauth/sign-in',
      data: {
        'provider': provider,
        'providerToken': providerToken,
        'storeId': AppConfig.storeId,
      },
    );
  }

  // Link OAuth provider
  Future<Response> linkOAuthProvider({
    required String userId,
    required String provider,
    required String providerToken,
  }) async {
    return await _apiClient.post(
      '/auth/oauth/link',
      data: {
        'userId': userId,
        'provider': provider,
        'providerToken': providerToken,
        'storeId': AppConfig.storeId,
      },
    );
  }
}
