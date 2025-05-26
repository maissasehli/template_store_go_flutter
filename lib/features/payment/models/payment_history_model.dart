class PaymentHistory {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? description;
  final String? receiptUrl;

  PaymentHistory({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
    this.description,
    this.receiptUrl,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      description: json['description'] as String?,
      receiptUrl: json['receipt_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'description': description,
      'receipt_url': receiptUrl,
    };
  }

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';

  bool get isSuccessful => status.toLowerCase() == 'succeeded';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';

  @override
  String toString() {
    return 'PaymentHistory(id: $id, orderId: $orderId, amount: $formattedAmount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
