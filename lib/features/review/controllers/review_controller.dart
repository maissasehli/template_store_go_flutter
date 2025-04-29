import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';

class ReviewController extends GetxController {
  final ReviewRepository _repository;
  final Logger _logger = Logger();
  final RxBool hasError = false.obs;

  final RxList<Review> reviews = <Review>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  ReviewController({required ReviewRepository repository}) : _repository = repository;

  @override
  void onInit() {
    super.onInit();
    // Sync offline reviews, updates, and deletes on initialization
    _syncOfflineData();
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> _syncOfflineData() async {
    try {
      await _repository.syncOfflineReviews();
      await _repository.syncOfflineUpdatesAndDeletes();
      _logger.i('Offline data synced successfully');
    } catch (e) {
      _logger.e('Error syncing offline data: $e');
      setError('Error syncing offline data: $e');
      Get.snackbar(
        'Warning',
        'Failed to sync offline data. Some changes may not be reflected.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchReviews(String productId) async {
    try {
      setLoading(true);
      clearError();

      final fetchedReviews = await _repository.getReviewsByProductId(productId);
      reviews.assignAll(fetchedReviews);
      _logger.i('Fetched ${reviews.length} reviews for product $productId');
    } catch (e) {
      setError('Error fetching reviews: $e');
      _logger.e('Error fetching reviews: $e');
      Get.snackbar(
        'Error',
        'Failed to load reviews',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<bool> addReview(String productId, Review review) async {
    try {
      setLoading(true);
      clearError();

      final success = await _repository.createReview(productId, review);
      if (success) {
        _logger.i('Review added successfully for product $productId');
        Get.snackbar('Success', 'Review submitted successfully', backgroundColor: Colors.green);
        return true;
      } else {
        throw Exception('Failed to create review: Saved offline');
      }
    } catch (e) {
      String errorMsg = 'Failed to submit review';
      if (e.toString().contains('You have already reviewed this product')) {
        errorMsg = 'You have already reviewed this product';
      } else if (e.toString().contains('User not authenticated')) {
        errorMsg = 'Please log in to submit a review';
      } else if (e.toString().contains('Product not found')) {
        errorMsg = 'Product not found';
      } else if (e.toString().contains('Saved offline')) {
        errorMsg = 'Review saved offline, will sync when online';
      }

      setError('Error adding review: $e');
      _logger.e('Error adding review: $e');
      Get.snackbar('Error', errorMsg, backgroundColor: Colors.red);
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateReview(String reviewId, Map<String, dynamic> updates) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateReview(reviewId, updates);
      final index = reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        final currentReview = reviews[index];
        reviews[index] = Review(
          id: currentReview.id,
          userName: currentReview.userName,
          appUserId: currentReview.appUserId,
          rating: updates['rating'] ?? currentReview.rating,
          content: updates['content'] ?? currentReview.content,
          createdAt: currentReview.createdAt,
        );
        reviews.refresh();
      }
      _logger.i('Review updated: $reviewId');
      Get.snackbar('Success', 'Review updated successfully', backgroundColor: Colors.green);
      return true;
    } catch (e) {
      String errorMsg = 'Failed to update review';
      if (e.toString().contains('Saved offline')) {
        errorMsg = 'Review update saved offline, will sync when online';
      }

      setError('Error updating review: $e');
      _logger.e('Error updating review: $e');
      Get.snackbar('Error', errorMsg, backgroundColor: Colors.red);
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    try {
      setLoading(true);
      clearError();

      _logger.i('Attempting to delete review with ID: $reviewId');
      await _repository.deleteReview(reviewId);
      reviews.removeWhere((r) => r.id == reviewId);
      _logger.i('Review deleted: $reviewId');
      Get.snackbar('Success', 'Review deleted successfully', backgroundColor: Colors.green);
      return true;
    } catch (e) {
      String errorMsg = 'Failed to delete review';
      if (e.toString().contains('Saved offline')) {
        errorMsg = 'Review deletion saved offline, will sync when online';
        // Remove locally even if saved offline
        reviews.removeWhere((r) => r.id == reviewId);
      } else if (e.toString().contains('404')) {
        errorMsg = 'Review not found on server, removed locally';
        reviews.removeWhere((r) => r.id == reviewId);
        Get.snackbar('Info', errorMsg, backgroundColor: Colors.orange);
        return true;
      }

      setError('Error deleting review: $e');
      _logger.e('Error deleting review: $e');
      Get.snackbar('Error', errorMsg, backgroundColor: Colors.red);
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<List<Review>> getReviewsByProductId(String productId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final fetchedReviews = await _repository.getReviewsByProductId(productId);
      _logger.d('Fetched ${fetchedReviews.length} reviews for product $productId');

      reviews.assignAll(fetchedReviews);
      return fetchedReviews;
    } catch (e) {
      _logger.e('Error fetching reviews for product $productId: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      reviews.clear();
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}