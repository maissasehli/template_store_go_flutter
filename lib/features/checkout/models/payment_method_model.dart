class PaymentMethod {
  final String id;
  final String type; // credit_card, paypal, etc.
  final Map<String, dynamic> details;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.details,
    this.isDefault = false,
  });

  factory PaymentMethod.empty() => PaymentMethod(id: '', type: '', details: {});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'] ?? '',
    type: json['type'] ?? '',
    details: json['details'] ?? {},
    isDefault: json['isDefault'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'details': details,
    'isDefault': isDefault,
  };

  String get displayName {
    switch (type) {
      case 'credit_card':
        final brand = details['brand'] ?? '';
        final last4 = details['last4'] ?? '';
        return '$brand •••• $last4';
      case 'paypal':
        return 'PayPal (${details['email'] ?? ''})';
      default:
        return type;
    }
  }
}
