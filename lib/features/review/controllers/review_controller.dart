import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/review/model/review_model.dart';
import 'package:store_go/features/review/repositories/review_repository.dart';

class ReviewController extends GetxController {
  final ReviewRepository _repository;
  final Logger _logger = Logger();

  // State
  final RxList<Review> reviews = <Review>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  ReviewController({required ReviewRepository repository})
      : _repository = repository;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
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
    } finally {
      setLoading(false);
    }
  }

  Future<void> addReview(String productId, Review review) async {
    try {
      setLoading(true);
      clearError();

      final success = await _repository.createReview(productId, review);
      if (success) {
        // Fetch the latest reviews to get the server-generated ID
        await fetchReviews(productId);
        _logger.i('Review added successfully for product $productId');
        Get.snackbar('Success', 'Review submitted successfully');
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
      }

      setError('Error adding review: $e');
      _logger.e('Error adding review: $e');
      Get.snackbar('Error', errorMsg);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateReview(reviewId, updates);
      final index = reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        final updatedReview = reviews[index].toJson();
        updatedReview.addAll(updates);
        reviews[index] = Review.fromJson(updatedReview);
        reviews.refresh();
      }
      _logger.i('Review updated: $reviewId');
      Get.snackbar('Success', 'Review updated successfully');
    } catch (e) {
      setError('Error updating review: $e');
      _logger.e('Error updating review: $e');
      Get.snackbar('Error', 'Failed to update review');
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      setLoading(true);
      clearError();

      await _repository.deleteReview(reviewId);
      reviews.removeWhere((r) => r.id == reviewId);
      _logger.i('Review deleted: $reviewId');
      Get.snackbar('Success', 'Review deleted successfully');
    } catch (e) {
      setError('Error deleting review: $e');
      _logger.e('Error deleting review: $e');
      Get.snackbar('Error', 'Failed to delete review');
    } finally {
      setLoading(false);
    }
  }
}