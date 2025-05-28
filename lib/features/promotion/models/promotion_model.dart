enum DiscountType {
  percentage,
  fixedAmount,
  freeShipping,
  buyXGetY
}

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

  // Listes des IDs de produits et catégories auxquels cette promotion s'applique
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
    // Analyser le type de remise depuis string vers enum
    DiscountType parseDiscountType(String type) {
      switch (type) {
        case 'percentage':
          return DiscountType.percentage;
        case 'fixed_amount':
          return DiscountType.fixedAmount;
        case 'free_shipping':
          return DiscountType.freeShipping;
        case 'buy_x_get_y':
          return DiscountType.buyXGetY;
        default:
          return DiscountType.percentage;
      }
    }

    // Analyser le tableau des produits
    List<String> parseProductIds(dynamic products) {
      if (products == null) return [];
      if (products is List) {
        return products
            .map((product) => product['product']?['id'] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
      }
      return [];
    }

    // Analyser le tableau des catégories
    List<String> parseCategoryIds(dynamic categories) {
      if (categories == null) return [];
      if (categories is List) {
        return categories
            .map((category) => category['category']?['id'] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
      }
      return [];
    }

    return Promotion(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      discountType: parseDiscountType(json['discountType'] as String),
      discountValue: double.tryParse(json['discountValue'].toString()) ?? 0.0,
      couponCode: json['couponCode'] as String?,
      minimumPurchase: double.tryParse(json['minimumPurchase'].toString()) ?? 0.0,
      buyQuantity: json['buyQuantity'] as int?,
      getQuantity: json['getQuantity'] as int?,
      sameProductOnly: json['sameProductOnly'] as bool?,
      promotionImage: json['promotionImage'] as String?,
      usageCount: json['usageCount'] as int? ?? 0,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      applicableProductIds: parseProductIds(json['products']),
      applicableCategoryIds: parseCategoryIds(json['categories']),
      yApplicableProductIds: parseProductIds(json['yProducts']),
      yApplicableCategoryIds: parseCategoryIds(json['yCategories']),
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
    };
  }

  String getDiscountDisplay() {
    switch (discountType) {
      case DiscountType.percentage:
        return '${discountValue.toStringAsFixed(0)}% OFF';
      case DiscountType.fixedAmount:
        return '\$${discountValue.toStringAsFixed(2)} OFF';
      case DiscountType.freeShipping:
        return 'LIVRAISON GRATUITE';
      case DiscountType.buyXGetY:
        return 'ACHETEZ $buyQuantity OBTENEZ $getQuantity';
    }
  }

  // NOUVELLE MÉTHODE : Obtenir le pourcentage de remise
  double get discountPercentage {
    if (discountType == DiscountType.percentage) {
      return discountValue;
    }
    return 0.0; // Pour les autres types de remise, retourner 0
  }

  // NOUVELLE MÉTHODE : Obtenir les catégories applicables (alias pour compatibilité)
  List<String> get applicableCategories => applicableCategoryIds;

  // NOUVELLE MÉTHODE : Calculer le prix avec remise
  double calculateDiscountedPrice(double originalPrice) {
    switch (discountType) {
      case DiscountType.percentage:
        return originalPrice * (1 - discountValue / 100);
      case DiscountType.fixedAmount:
        final discountedPrice = originalPrice - discountValue;
        return discountedPrice > 0 ? discountedPrice : 0;
      case DiscountType.freeShipping:
        return originalPrice; // Le prix reste le même, seule la livraison est gratuite
      case DiscountType.buyXGetY:
        return originalPrice; // Logique complexe, à implémenter selon les besoins
    }
  }

  // NOUVELLE MÉTHODE : Vérifier si la promotion est actuellement active
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(endDate);
  }

  // NOUVELLE MÉTHODE : Obtenir les jours restants
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  // NOUVELLE MÉTHODE : Formater la date d'expiration
  String get formattedExpiryDate {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'Expire aujourd\'hui';
    } else if (difference == 1) {
      return 'Expire demain';
    } else if (difference < 7) {
      return 'Expire dans $difference jours';
    } else {
      return 'Expire le ${endDate.day}/${endDate.month}/${endDate.year}';
    }
  }

  // Méthode helper pour vérifier si la promotion s'applique à un produit spécifique
  bool appliesToProduct(String productId) {
    return applicableProductIds.contains(productId);
  }

  // Méthode helper pour vérifier si la promotion s'applique à une catégorie spécifique
  bool appliesToCategory(String categoryId) {
    return applicableCategoryIds.contains(categoryId);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Promotion &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}