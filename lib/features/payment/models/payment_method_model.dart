class PaymentMethod {
  final String id;
  final String type;
  final String? last4;
  final String? brand;
  final int? expiryMonth;
  final int? expiryYear;
  final bool isDefault;
  final DateTime createdAt;
  final String? stripePaymentMethodId;
  final Map<String, dynamic>? details;

  PaymentMethod({
    required this.id,
    required this.type,
    this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    required this.isDefault,
    required this.createdAt,
    this.stripePaymentMethodId,
    this.details,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      last4: json['last4'] as String?,
      brand: json['brand'] as String?,
      expiryMonth: json['expiry_month'] as int? ?? json['expiryMonth'] as int?,
      expiryYear: json['expiry_year'] as int? ?? json['expiryYear'] as int?,
      isDefault:
          json['isDefault'] as bool? ?? json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? json['created_at'] as String,
      ),
      stripePaymentMethodId: json['stripePaymentMethodId'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      if (last4 != null) 'last4': last4,
      if (brand != null) 'brand': brand,
      if (expiryMonth != null) 'expiry_month': expiryMonth,
      if (expiryYear != null) 'expiry_year': expiryYear,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      if (stripePaymentMethodId != null)
        'stripePaymentMethodId': stripePaymentMethodId,
      if (details != null) 'details': details,
    };
  }

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? last4,
    String? brand,
    int? expiryMonth,
    int? expiryYear,
    bool? isDefault,
    DateTime? createdAt,
    String? stripePaymentMethodId,
    Map<String, dynamic>? details,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      stripePaymentMethodId:
          stripePaymentMethodId ?? this.stripePaymentMethodId,
      details: details ?? this.details,
    );
  }

  String get displayName {
    if (last4 != null && brand != null) {
      return '$brand •••• $last4';
    } else if (details?['cardholderName'] != null) {
      return '${details!['cardholderName']} • ${type.replaceAll('_', ' ').toUpperCase()}';
    }
    return type.replaceAll('_', ' ').toUpperCase();
  }

  String get formattedExpiry {
    if (expiryMonth != null && expiryYear != null) {
      return '${expiryMonth.toString().padLeft(2, '0')}/${expiryYear.toString().substring(2)}';
    }
    return '';
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $id, type: $type, brand: $brand, last4: $last4, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
