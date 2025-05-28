import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'dart:developer' as developer;

import '../models/promotion_model.dart';

class PromotionRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();
  
  PromotionRepository({required ApiClient apiClient}) : _apiClient = apiClient;
  
  // Cache for storing promotions by product ID
  final Map<String, List<Promotion>> _productPromotionsCache = {};
  
  // Get all active promotions
  Future<List<Promotion>> getAllPromotions({bool forceRefresh = false}) async {
    try {
      final response = await _apiClient.get('/promotions');
      developer.log(
        'Get promotions response: ${response.data}',
        name: 'PromotionRepository.getAllPromotions',
      );
      
      if (response.statusCode == 200) {
        List<dynamic> promotionsJson = response.data['data'] ?? [];
        List<Promotion> promotions = promotionsJson
            .map((json) => Promotion.fromJson(json))
            .toList();
        
        return promotions;
      } else {
        throw Exception('Failed to load promotions: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error fetching promotions: $e');
      throw Exception('Error fetching promotions: $e');
    }
  }
  
  // Get all active promotions - NEW METHOD
 
  // Get promotions for a specific product
  Future<List<Promotion>> getPromotionsByProductId(
    String productId, {
    bool forceRefresh = false,
  }) async {
    // Return from cache if available and not forcing refresh
    if (!forceRefresh && _productPromotionsCache.containsKey(productId)) {
      return _productPromotionsCache[productId]!;
    }
    
    try {
      final response = await _apiClient.get('/promotions/product/$productId');
      developer.log(
        'Get product promotions response: ${response.data}',
        name: 'PromotionRepository.getPromotionsByProductId',
      );
      
      if (response.statusCode == 200) {
        List<dynamic> promotionsJson = response.data['data'] ?? [];
        List<Promotion> promotions = promotionsJson
            .map((json) => Promotion.fromJson(json))
            .toList();
        
        // Cache the result
        _productPromotionsCache[productId] = promotions;
        
        return promotions;
      } else {
        throw Exception('Failed to load product promotions: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error fetching product promotions: $e');
      // Return empty list on error for better user experience
      return [];
    }
  }
  
  // Get a specific promotion by ID
  Future<Promotion?> getPromotionById(String promotionId) async {
    try {
      final response = await _apiClient.get('/promotions/$promotionId');
      developer.log(
        'Get promotion by ID response: ${response.data}',
        name: 'PromotionRepository.getPromotionById',
      );
      
      if (response.statusCode == 200) {
        final promotionJson = response.data['data'];
        if (promotionJson != null) {
          return Promotion.fromJson(promotionJson);
        }
        return null;
      } else {
        throw Exception('Failed to load promotion: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error fetching promotion: $e');
      return null;
    }
  }
  
  // Clear cache
  void clearCache() {
    _productPromotionsCache.clear();
  }
}