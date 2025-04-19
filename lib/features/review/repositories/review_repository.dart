import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'dart:developer' as developer;

class ReviewRepository {
  final ApiClient _apiClient;
  static const String _reviewsEndpoint = '/reviews/product';
  static const String _offlineReviewsKey = 'offline_reviews';

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
        // Only send the fields the server expects
        final reviewData = {
          'rating': review.rating,
          'content': review.content,
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
          // Last retry failed, save offline
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

    // Exclude the temporary id when saving offline
    final reviewData = {
      'rating': review.rating,
      'content': review.content,
      'createdAt': review.createdAt.toIso8601String(),
      'userName': review.userName,
    };

    offlineData[productId]!.add(reviewData);
    await prefs.setString(_offlineReviewsKey, jsonEncode(offlineData));
    developer.log('Saved review offline for product $productId', name: 'ReviewRepository.saveReviewOffline');
  }

  Future<void> syncOfflineReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final offlineReviews = prefs.getString(_offlineReviewsKey) ?? '{}';
    final Map<String, List<dynamic>> offlineData = jsonDecode(offlineReviews);

    for (final productId in offlineData.keys) {
      final reviews = offlineData[productId]!;
      for (final reviewJson in List.from(reviews)) {
        final review = Review(
          id: DateTime.now().toString(), // Temporary ID for the sync attempt
          userName: reviewJson['userName'] ?? 'Anonymous',
          rating: reviewJson['rating'],
          content: reviewJson['content'],
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

  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put(
        '/reviews/$reviewId',
        data: updates,
      );
      developer.log('Update review response: ${response.data}', name: 'ReviewRepository.updateReview');

      if (response.statusCode != 200) {
        throw Exception('Failed to update review: ${response.statusMessage}');
      }
    } catch (e) {
      developer.log('Error updating review: $e', name: 'ReviewRepository.updateReview', error: e);
      throw Exception('Error updating review: $e');
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
      throw Exception('Error deleting review: $e');
    }
  }
}