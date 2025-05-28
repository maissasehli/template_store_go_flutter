enum DiscountType { percentage, fixedAmount, freeShipping, buyXGetY }

class Promotion {
  final String id;
  final String name;
  final String? description;
  final DiscountType discountType;
  final double discountValue;
  final String? couponCode;
  final double minimumPurchase;
  final int? buyQuantity;
  final int? getQuantity;
  final bool? sameProductOnly;
  final String? promotionImage;
  final int usageCount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<String> applicableProductIds;
  final List<String> applicableCategoryIds;
  final List<String> yApplicableProductIds;
  final List<String> yApplicableCategoryIds;

  Promotion({
    required this.id,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.couponCode,
    required this.minimumPurchase,
    this.buyQuantity,
    this.getQuantity,
    this.sameProductOnly,
    this.promotionImage,
    required this.usageCount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.applicableProductIds = const [],
    this.applicableCategoryIds = const [],
    this.yApplicableProductIds = const [],
    this.yApplicableCategoryIds = const [],
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    DiscountType parseDiscountType(String? type) {
      switch (type?.toLowerCase()) {
        case 'percentage':
          return DiscountType.percentage;
        case 'fixed_amount':
        case 'fixedamount':
          return DiscountType.fixedAmount;
        case 'free_shipping':
        case 'freeshipping':
          return DiscountType.freeShipping;
        case 'buy_x_get_y':
        case 'buyxgety':
          return DiscountType.buyXGetY;
        default:
          return DiscountType.percentage; // Default to percentage if unknown
      }
    }

    List<String> parseProductIds(dynamic products) {
      if (products == null) return [];
      if (products is List) {
        return products
            .map((product) {
              if (product is Map<String, dynamic>) {
                return product['product']?['id'] as String? ?? '';
              } else if (product is String) {
                return product;
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      return [];
    }

    List<String> parseCategoryIds(dynamic categories) {
      if (categories == null) return [];
      if (categories is List) {
        return categories
            .map((category) {
              if (category is Map<String, dynamic>) {
                return category['category']?['id'] as String? ?? '';
              } else if (category is String) {
                return category;
              }
              return '';
            })
            .where((id) => id.isNotEmpty)
            .toList();
      }
      return [];
    }

    return Promotion(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Promotion',
      description: json['description'] as String?,
      discountType: parseDiscountType(json['discountType'] as String?),
      discountValue: double.tryParse(json['discountValue']?.toString() ?? '0') ?? 0.0,
      couponCode: json['couponCode'] as String?,
      minimumPurchase: double.tryParse(json['minimumPurchase']?.toString() ?? '0') ?? 0.0,
      buyQuantity: json['buyQuantity'] as int?,
      getQuantity: json['getQuantity'] as int?,
      sameProductOnly: json['sameProductOnly'] as bool? ?? false,
      promotionImage: json['promotionImage'] as String?,
      usageCount: json['usageCount'] as int? ?? 0,
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      applicableProductIds: parseProductIds(json['products'] ?? json['applicableProductIds']),
      applicableCategoryIds: parseCategoryIds(json['categories'] ?? json['applicableCategoryIds']),
      yApplicableProductIds: parseProductIds(json['yProducts'] ?? json['yApplicableProductIds']),
      yApplicableCategoryIds: parseCategoryIds(json['yCategories'] ?? json['yApplicableCategoryIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'discountType': discountType.toString().split('.').last,
      'discountValue': discountValue,
      'couponCode': couponCode,
      'minimumPurchase': minimumPurchase,
      'buyQuantity': buyQuantity,
      'getQuantity': getQuantity,
      'sameProductOnly': sameProductOnly,
      'promotionImage': promotionImage,
      'usageCount': usageCount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'applicableProductIds': applicableProductIds,
      'applicableCategoryIds': applicableCategoryIds,
      'yApplicableProductIds': yApplicableProductIds,
      'yApplicableCategoryIds': yApplicableCategoryIds,
    };
  }

  String getDiscountDisplay() {
    switch (discountType) {
      case DiscountType.percentage:
        return '${discountValue.toStringAsFixed(0)}% OFF';
      case DiscountType.fixedAmount:
        return '\$${discountValue.toStringAsFixed(2)} OFF';
      case DiscountType.freeShipping:
        return 'FREE SHIPPING';
      case DiscountType.buyXGetY:
        return 'BUY $buyQuantity GET $getQuantity';
    }
  }

  double get discountPercentage {
    if (discountType == DiscountType.percentage) {
      return discountValue;
    }
    return 0.0;
  }

  List<String> get applicableCategories => applicableCategoryIds;

  double calculateDiscountedPrice(double originalPrice) {
    switch (discountType) {
      case DiscountType.percentage:
        return originalPrice * (1 - discountValue / 100);
      case DiscountType.fixedAmount:
        final discountedPrice = originalPrice - discountValue;
        return discountedPrice > 0 ? discountedPrice : 0;
      case DiscountType.freeShipping:
        return originalPrice;
      case DiscountType.buyXGetY:
        return originalPrice; // Implement specific logic if needed
    }
  }

  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  String get formattedExpiryDate {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;

    if (difference == 0) {
      return 'Expires today';
    } else if (difference == 1) {
      return 'Expires tomorrow';
    } else if (difference < 7) {
      return 'Expires in $difference days';
    } else {
      return 'Expires on ${endDate.day}/${endDate.month}/${endDate.year}';
    }
  }

  bool appliesToProduct(String productId) {
    return applicableProductIds.contains(productId);
  }

  bool appliesToCategory(String categoryId) {
    return applicableCategoryIds.contains(categoryId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Promotion && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}