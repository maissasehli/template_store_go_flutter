import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/services/api_client.dart';

class PaymentRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetch all payment methods for the authenticated user
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _apiClient.get('/payment-methods');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => PaymentMethod.fromJson(item)).toList();
      } else {
        _logger.w('Failed to fetch payment methods: ${response.statusCode}');
        throw Exception('Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching payment methods: $e');
      throw Exception('Failed to load payment methods: $e');
    }
  }

  /// Add a new payment method
  Future<PaymentMethod> addPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final data = paymentMethod.toJson();
      final response = await _apiClient.post('/payment-methods', data: data);
      if (response.statusCode == 201) {
        return PaymentMethod.fromJson(response.data['data']);
      } else {
        _logger.w('Failed to add payment method: ${response.statusCode}');
        throw Exception('Failed to add payment method: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error adding payment method: $e');
      throw Exception('Failed to add payment method: $e');
    }
  }
}

class PaymentMethod {
  final String id;
  final String type; // e.g., 'card', 'paypal'
  final String lastFour; // e.g., '4187' for card
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'card',
      lastFour: json['last_four']?.toString() ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'last_four': lastFour,
      'is_default': isDefault,
    };
  }

  String get displayName => type == 'card' ? '**** $lastFour' : type.capitalizeFirst!;
}