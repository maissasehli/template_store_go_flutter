class PaymentRequest {
  final String orderId;
  final double amount;
  final String currency;
  final String? paymentMethodId;
  final bool savePaymentMethod;
  final Map<String, dynamic>? metadata;

  PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.currency,
    this.paymentMethodId,
    this.savePaymentMethod = false,
    this.metadata,
  });
  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': 'credit_card', // Fixed according to Bruno API
      'paymentToken': paymentMethodId, // Map paymentMethodId to paymentToken
      'savePaymentMethod': savePaymentMethod,
      // Note: Bruno API doesn't expect amount, currency, etc. for order payment
      // These are likely handled server-side based on the orderId
    };
  }

  PaymentRequest copyWith({
    String? orderId,
    double? amount,
    String? currency,
    String? paymentMethodId,
    bool? savePaymentMethod,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentRequest(
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      savePaymentMethod: savePaymentMethod ?? this.savePaymentMethod,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'PaymentRequest(orderId: $orderId, amount: $amount, currency: $currency)';
  }
}
