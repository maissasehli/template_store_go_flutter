import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'dart:developer' as developer;

class ReviewRepository {
  final ApiClient _apiClient;
  static const String _reviewsEndpoint = '/reviews/product';
  static const String _offlineReviewsKey = 'offline_reviews';
  static const String _offlineUpdatesKey = 'offline_review_updates';
  static const String _offlineDeletesKey = 'offline_review_deletes';

  ReviewRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Review>> getReviewsByProductId(String productId) async {
    try {
      final response = await _apiClient.get('$_reviewsEndpoint/$productId');
      developer.log('Get reviews response: ${response.data}', name: 'ReviewRepository.getReviewsByProductId');

      if (response.statusCode == 200) {
        List<dynamic> reviewsJson = response.data['data'] ?? [];
        return reviewsJson.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error fetching reviews: $e', name: 'ReviewRepository.getReviewsByProductId', error: e);
      throw Exception('Error fetching reviews: $e');
    }
  }

  Future<bool> createReview(String productId, Review review, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        final reviewData = {
          'rating': review.rating,
          'content': review.content,
          'appUserId': review.appUserId,
        };

        developer.log('Submitting review: $reviewData', name: 'ReviewRepository.createReview');

        final response = await _apiClient.post(
          '$_reviewsEndpoint/$productId',
          data: reviewData,
        );

        developer.log('Create review response: ${response.data}', name: 'ReviewRepository.createReview');

        if (response.statusCode == 201) {
          return true;
        } else {
          throw Exception('Failed to create review: ${response.statusMessage}');
        }
      } catch (e) {
        developer.log('Attempt ${i + 1} failed: $e', name: 'ReviewRepository.createReview', error: e);
        if (i == retries - 1) {
          await saveReviewOffline(productId, review);
          return false;
        }
        await Future.delayed(Duration(seconds: 2));
      }
    }
    return false;
  }

  Future<void> saveReviewOffline(String productId, Review review) async {
    final prefs = await SharedPreferences.getInstance();
    final offlineReviews = prefs.getString(_offlineReviewsKey) ?? '{}';
    final Map<String, List<dynamic>> offlineData = jsonDecode(offlineReviews);

    if (!offlineData.containsKey(productId)) {
      offlineData[productId] = [];
    }

    final reviewData = {
      'rating': review.rating,
      'content': review.content,
      'createdAt': review.createdAt.toIso8601String(),
      'userName': review.userName,
      'appUserId': review.appUserId,
    };

    offlineData[productId]!.add(reviewData);
    await prefs.setString(_offlineReviewsKey, jsonEncode(offlineData));
    developer.log('Saved review offline for product $productId', name: 'ReviewRepository.saveReviewOffline');
  }

  Future<void> saveUpdateOffline(String reviewId, Map<String, dynamic> updates) async {
    final prefs = await SharedPreferences.getInstance();
    final offlineUpdates = prefs.getString(_offlineUpdatesKey) ?? '{}';
    final Map<String, Map<String, dynamic>> offlineData = jsonDecode(offlineUpdates);

    offlineData[reviewId] = updates;
    await prefs.setString(_offlineUpdatesKey, jsonEncode(offlineData));
    developer.log('Saved review update offline for review $reviewId', name: 'ReviewRepository.saveUpdateOffline');
  }
Future<void> saveDeleteOffline(String reviewId) async {
  if (reviewId.isEmpty) {
    developer.log('Invalid reviewId: $reviewId. Not saving offline delete.', name: 'ReviewRepository.saveDeleteOffline');
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final offlineDeletes = prefs.getString(_offlineDeletesKey) ?? '[]';
  final List<String> offlineData = jsonDecode(offlineDeletes);

  if (!offlineData.contains(reviewId)) {
    offlineData.add(reviewId);
    await prefs.setString(_offlineDeletesKey, jsonEncode(offlineData));
    developer.log('Saved review delete offline for review $reviewId', name: 'ReviewRepository.saveDeleteOffline');
  }
}

Future<void> syncOfflineReviews() async {
  final prefs = await SharedPreferences.getInstance();
  final offlineReviewsJson = prefs.getString(_offlineReviewsKey) ?? '{}';
  final offlineDataRaw = jsonDecode(offlineReviewsJson);

  // Validate and convert the raw data
  if (offlineDataRaw is! Map<String, dynamic>) {
    developer.log('Invalid offline reviews format. Resetting to empty.', name: 'ReviewRepository.syncOfflineReviews');
    await prefs.setString(_offlineReviewsKey, '{}');
    return;
  }

  final Map<String, List<dynamic>> offlineData = {};
  for (var entry in offlineDataRaw.entries) {
    final productId = entry.key;
    final reviewsList = entry.value;

    if (reviewsList is List<dynamic>) {
      offlineData[productId] = reviewsList;
    } else {
      developer.log('Invalid reviews list for product $productId. Skipping.', name: 'ReviewRepository.syncOfflineReviews');
      continue;
    }
  }

  for (final productId in offlineData.keys) {
    final reviews = offlineData[productId]!;
    for (final reviewJson in List.from(reviews)) {
      if (reviewJson is! Map<String, dynamic>) {
        developer.log('Invalid review format for product $productId. Skipping.', name: 'ReviewRepository.syncOfflineReviews');
        reviews.remove(reviewJson);
        continue;
      }

      final review = Review(
        id: DateTime.now().toString(),
        userName: reviewJson['userName'] ?? 'Anonymous',
        appUserId: reviewJson['appUserId'] ?? '',
        rating: reviewJson['rating'] is int ? reviewJson['rating'] : int.tryParse(reviewJson['rating'].toString()) ?? 0,
        content: reviewJson['content']?.toString(),
        createdAt: DateTime.parse(reviewJson['createdAt']),
      );
      final success = await createReview(productId, review);
      if (success) {
        reviews.remove(reviewJson);
      }
    }
    offlineData[productId] = reviews;
  }

  offlineData.removeWhere((key, value) => value.isEmpty);
  if (offlineData.isEmpty) {
    await prefs.remove(_offlineReviewsKey);
  } else {
    await prefs.setString(_offlineReviewsKey, jsonEncode(offlineData));
  }
}
Future<void> syncOfflineUpdatesAndDeletes() async {
  final prefs = await SharedPreferences.getInstance();

  // Sync offline updates
  final offlineUpdatesJson = prefs.getString(_offlineUpdatesKey) ?? '{}';
  final offlineUpdateDataRaw = jsonDecode(offlineUpdatesJson);

  if (offlineUpdateDataRaw is! Map<String, dynamic>) {
    developer.log('Invalid offline updates format. Resetting to empty.', name: 'ReviewRepository.syncOfflineUpdates');
    await prefs.setString(_offlineUpdatesKey, '{}');
    return;
  }

  final Map<String, Map<String, dynamic>> offlineUpdateData = {};
  for (var entry in offlineUpdateDataRaw.entries) {
    final reviewId = entry.key;
    final updates = entry.value;

    if (updates is Map<String, dynamic>) {
      offlineUpdateData[reviewId] = updates;
    } else {
      developer.log('Invalid updates for review $reviewId. Skipping.', name: 'ReviewRepository.syncOfflineUpdates');
      continue;
    }
  }

  for (final reviewId in offlineUpdateData.keys.toList()) {
    try {
      await updateReview(reviewId, offlineUpdateData[reviewId]!);
      offlineUpdateData.remove(reviewId);
    } catch (e) {
      developer.log('Failed to sync update for review $reviewId: $e', name: 'ReviewRepository.syncOfflineUpdates');
    }
  }
  await prefs.setString(_offlineUpdatesKey, jsonEncode(offlineUpdateData));

  // Sync offline deletes
  final offlineDeletesJson = prefs.getString(_offlineDeletesKey) ?? '[]';
  final offlineDeleteDataRaw = jsonDecode(offlineDeletesJson);

  if (offlineDeleteDataRaw is! List<dynamic>) {
    developer.log('Invalid offline deletes format. Resetting to empty.', name: 'ReviewRepository.syncOfflineDeletes');
    await prefs.setString(_offlineDeletesKey, '[]');
    return;
  }

  final List<String> offlineDeleteData = offlineDeleteDataRaw
      .whereType<String>()
      .cast<String>()
      .toList();

  for (final reviewId in List.from(offlineDeleteData)) {
    try {
      await deleteReview(reviewId);
      offlineDeleteData.remove(reviewId);
    } catch (e) {
      developer.log('Failed to sync delete for review $reviewId: $e', name: 'ReviewRepository.syncOfflineDeletes');
    }
  }
  await prefs.setString(_offlineDeletesKey, jsonEncode(offlineDeleteData));
}

  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put('/reviews/$reviewId', data: updates);
      developer.log('Update review response: ${response.data}', name: 'ReviewRepository.updateReview');

      if (response.statusCode != 200) {
        throw Exception('Failed to update review: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error updating review: $e', name: 'ReviewRepository.updateReview', error: e);
      await saveUpdateOffline(reviewId, updates);
      throw Exception('Error updating review: Saved offline');
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await _apiClient.delete('/reviews/$reviewId');
      developer.log('Delete review response: ${response.data}', name: 'ReviewRepository.deleteReview');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete review: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error deleting review: $e', name: 'ReviewRepository.deleteReview', error: e);
      await saveDeleteOffline(reviewId);
      throw Exception('Error deleting review: Saved offline');
    }
  }
}