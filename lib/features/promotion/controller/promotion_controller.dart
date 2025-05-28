import 'package:get/get.dart';
import 'package:store_go/features/promotion/models/promotion_model.dart';
import 'package:store_go/features/promotion/repositories/promotion_repository.dart';
import 'dart:developer' as developer;

import 'package:store_go/features/promotion/views/widgets/promotion_state.dart';

class PromotionController extends GetxController {
  final PromotionRepository _promotionRepository;
  final PromotionState state = PromotionState();
  String? _lastFetchedProductId;

  // Observable list for home page promotions with images
  final RxList<Promotion> _homePromotions = <Promotion>[].obs;
  final RxBool _isLoadingHomePromotions = false.obs;

  PromotionController({required PromotionRepository promotionRepository})
      : _promotionRepository = promotionRepository;

  // Getters for home promotions
  List<Promotion> get homePromotions => _homePromotions;
  bool get isLoadingHomePromotions => _isLoadingHomePromotions.value;

  /// Check if a promotion is currently active
  bool _isPromotionActive(Promotion promotion) {
    final now = DateTime.now();
    return promotion.isActive && 
           now.isAfter(promotion.startDate) && 
           now.isBefore(promotion.endDate);
  }

  /// Get all active promotions - fonction privée dans le controller
  Future<List<Promotion>> _getAllActivePromotions() async {
    try {
      // Récupérer toutes les promotions depuis le repository
      final allPromotions = await _promotionRepository.getAllPromotions();
      
      // Filtrer pour obtenir seulement les promotions actives
      final activePromotions = allPromotions.where((promotion) {
        return _isPromotionActive(promotion);
      }).toList();

      developer.log(
        'Filtered ${activePromotions.length} active promotions from ${allPromotions.length} total',
        name: 'PromotionController._getAllActivePromotions',
      );

      return activePromotions;
    } catch (e) {
      developer.log(
        'Error in _getAllActivePromotions: $e',
        name: 'PromotionController._getAllActivePromotions',
        error: e,
      );
      rethrow;
    }
  }

  /// Fetch active promotions with images for home page display
  Future<void> fetchHomePromotions() async {
    _isLoadingHomePromotions.value = true;
    
    try {
      developer.log(
        'Fetching active promotions with images for home page',
        name: 'PromotionController.fetchHomePromotions',
      );

      // Utiliser la fonction privée pour obtenir les promotions actives
      final allPromotions = await _getAllActivePromotions();
      
      // Filtrer les promotions qui ont des images
      final promotionsWithImages = allPromotions.where((promotion) {
        final hasImage = promotion.promotionImage != null && 
                        promotion.promotionImage!.isNotEmpty;
        return hasImage;
      }).toList();

      // Trier par date de début (plus récent en premier)
      promotionsWithImages.sort((a, b) => b.startDate.compareTo(a.startDate));

      _homePromotions.value = promotionsWithImages;

      developer.log(
        'Found ${promotionsWithImages.length} active promotions with images',
        name: 'PromotionController.fetchHomePromotions',
      );

    } catch (e) {
      developer.log(
        'Error fetching home promotions: $e',
        name: 'PromotionController.fetchHomePromotions',
        error: e,
      );
      _homePromotions.clear();
    } finally {
      _isLoadingHomePromotions.value = false;
    }
  }

  /// Check if there are any promotions with images to display
  bool get hasHomePromotions => _homePromotions.isNotEmpty;

  /// Fetch promotions for a specific product - FIXED VERSION
  Future<void> fetchPromotionsByProductId(String productId) async {
    // Clear previous error state
    state.clearError();
    
    // Prevent unnecessary refetching if we already have promotions for this product
    if (_lastFetchedProductId == productId &&
        state.productPromotions.isNotEmpty &&
        !state.hasError.value) {
      developer.log(
        'Promotions already cached for product: $productId, count: ${state.productPromotions.length}',
        name: 'PromotionController.fetchPromotionsByProductId',
      );
      return;
    }

    state.setLoading(true);

    try {
      developer.log(
        'Fetching promotions for product: $productId',
        name: 'PromotionController.fetchPromotionsByProductId',
      );

      // Get all active promotions first
      final allActivePromotions = await _getAllActivePromotions();
      
      // Filter promotions that apply to this specific product
      final productPromotions = allActivePromotions.where((promotion) {
        // Check if promotion applies to this product specifically
        bool appliesDirectly = promotion.appliesToProduct(productId);
        
        developer.log(
          'Promotion ${promotion.name}: appliesDirectly=$appliesDirectly, '
          'applicableProductIds=${promotion.applicableProductIds}',
          name: 'PromotionController.fetchPromotionsByProductId',
        );
        
        return appliesDirectly;
      }).toList();

      developer.log(
        'Found ${productPromotions.length} active promotions for product $productId',
        name: 'PromotionController.fetchPromotionsByProductId',
      );

      // Also try to get promotions from the API endpoint (fallback)
      try {
        final apiPromotions = await _promotionRepository.getPromotionsByProductId(productId);
        
        // Filter API promotions to only include active ones
        final activeApiPromotions = apiPromotions.where((promotion) => 
          _isPromotionActive(promotion)
        ).toList();
        
        developer.log(
          'Found ${activeApiPromotions.length} active promotions from API for product $productId',
          name: 'PromotionController.fetchPromotionsByProductId',
        );
        
        // Merge the two lists and remove duplicates
        final allPromotions = <Promotion>[];
        final seenIds = <String>{};
        
        for (final promotion in [...productPromotions, ...activeApiPromotions]) {
          if (!seenIds.contains(promotion.id)) {
            allPromotions.add(promotion);
            seenIds.add(promotion.id);
          }
        }
        
        _lastFetchedProductId = productId;
        
        if (allPromotions.isNotEmpty) {
          developer.log(
            'Total ${allPromotions.length} unique active promotions found for product $productId',
            name: 'PromotionController.fetchPromotionsByProductId',
          );
          state.setProductPromotions(allPromotions);
        } else {
          developer.log(
            'No active promotions found for product $productId',
            name: 'PromotionController.fetchPromotionsByProductId',
          );
          state.clearPromotions();
        }
      } catch (apiError) {
        developer.log(
          'API fallback failed, using filtered promotions only: $apiError',
          name: 'PromotionController.fetchPromotionsByProductId',
        );
        
        _lastFetchedProductId = productId;
        
        if (productPromotions.isNotEmpty) {
          state.setProductPromotions(productPromotions);
        } else {
          state.clearPromotions();
        }
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
      final promotion = await _promotionRepository.getPromotionById(
        promotionId,
      );
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
    _lastFetchedProductId = null; // Reset cache
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

  /// Refresh home promotions
  Future<void> refreshHomePromotions() async {
    await fetchHomePromotions();
  }

  /// Clear home promotions cache  
  void clearHomePromotions() {
    _homePromotions.clear();
  }

  /// Force refresh promotions for a product (clears cache)
  Future<void> refreshPromotionsForProduct(String productId) async {
    _lastFetchedProductId = null;
    state.clearPromotions();
    await fetchPromotionsByProductId(productId);
  }

  @override
  void onClose() {
    // Clean up resources if needed
    _homePromotions.clear();
    super.onClose();
  }
}