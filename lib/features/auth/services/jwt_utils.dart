import 'dart:convert';
import 'package:logger/logger.dart';

/// Utilities for working with JWT tokens
class JwtUtils {
  final Logger _logger = Logger();

  // Extract user data from JWT token
  Map<String, dynamic>? extractJwtData(String? jwtToken) {
    if (jwtToken == null) return null;

    try {
      // Split the token into 3 parts
      final parts = jwtToken.split('.');
      if (parts.length != 3) return null;

      // Get the payload (middle part)
      final payload = parts[1];

      // Add padding if needed
      String normalized = payload;
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }

      // Decode base64
      final decodedPayload = utf8.decode(base64Url.decode(normalized));

      // Parse JSON
      return json.decode(decodedPayload) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Error decoding JWT token: $e');
      return null;
    }
  }

  // Verify token structure (not cryptographic verification)
  bool isValidJwtFormat(String? token) {
    if (token == null) return false;

    final parts = token.split('.');
    return parts.length == 3;
  }

  // Get token expiration time
  DateTime? getTokenExpiration(String? token) {
    final payload = extractJwtData(token);
    if (payload == null) return null;

    // Look for standard exp claim
    if (payload.containsKey('exp')) {
      final exp = payload['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    }

    return null;
  }

  // Check if token is expired
  bool isTokenExpired(String? token) {
    final expiration = getTokenExpiration(token);
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }
}
