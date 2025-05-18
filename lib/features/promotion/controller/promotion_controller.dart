import 'package:get/get.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/repositories/promotion_repository.dart';
import 'dart:developer' as developer;

import 'package:store_go/features/promotion/views/promotion_state.dart';

class PromotionController extends GetxController {
  final PromotionRepository _promotionRepository;
  final PromotionState state = PromotionState();

  PromotionController({required PromotionRepository promotionRepository})
      : _promotionRepository = promotionRepository;

  Future<void> fetchPromotionsByProductId(String productId) async {
    state.setLoading(true);
    state.clearError();

    try {
      developer.log(
        'Fetching promotions for product: $productId',
        name: 'PromotionController.fetchPromotionsByProductId',
      );

      final promotions = await _promotionRepository.getPromotionsByProductId(productId);
      
      if (promotions.isNotEmpty) {
        developer.log(
          'Found ${promotions.length} promotions for product $productId',
          name: 'PromotionController.fetchPromotionsByProductId',
        );
        state.setProductPromotions(promotions);
      } else {
        developer.log(
          'No promotions found for product $productId',
          name: 'PromotionController.fetchPromotionsByProductId',
        );
        state.clearPromotions();
      }
    } catch (e) {
      developer.log(
        'Error fetching promotions: $e',
        name: 'PromotionController.fetchPromotionsByProductId',
        error: e,
      );
      state.setError('Failed to load promotions');
      state.clearPromotions();
    } finally {
      state.setLoading(false);
    }
  }

  Future<Promotion?> fetchPromotionById(String promotionId) async {
    state.setLoading(true);
    state.clearError();

    try {
      final promotion = await _promotionRepository.getPromotionById(promotionId);
      state.setLoading(false);
      return promotion;
    } catch (e) {
      developer.log(
        'Error fetching promotion details: $e',
        name: 'PromotionController.fetchPromotionById',
        error: e,
      );
      state.setError('Failed to load promotion details');
      state.setLoading(false);
      return null;
    }
  }

  void updateCurrentPromotionIndex(int index) {
    state.setCurrentPromotionIndex(index);
  }

  void nextPromotion() {
    state.nextPromotion();
  }

  void previousPromotion() {
    state.previousPromotion();
  }

  void togglePromotionSheet() {
    state.togglePromotionSheet();
  }

  void openPromotionSheet() {
    state.openPromotionSheet();
  }

  void closePromotionSheet() {
    state.closePromotionSheet();
  }

  void clearPromotions() {
    state.clearPromotions();
  }

  // Add these methods to handle the selectedPromotion
  void setSelectedPromotion(Promotion promotion) {
    state.setSelectedPromotion(promotion);
  }

  void clearSelectedPromotion() {
    state.clearSelectedPromotion();
  }

  // Add a getter for the selectedPromotion
  Rx<Promotion?> get selectedPromotion => state.selectedPromotion;

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}