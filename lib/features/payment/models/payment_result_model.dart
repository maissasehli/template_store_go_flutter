enum PaymentStatus { success, requiresAction, failed, processing }

class PaymentResult {
  final PaymentStatus status;
  final String? paymentId;
  final String? orderId;
  final String? paymentIntentId;
  final String? clientSecret;
  final String? error;
  final String message;

  PaymentResult({
    required this.status,
    this.paymentId,
    this.orderId,
    this.paymentIntentId,
    this.clientSecret,
    this.error,
    required this.message,
  });

  factory PaymentResult.success({
    String? paymentId,
    String? orderId,
    String? paymentIntentId,
    String message = 'Payment successful',
  }) {
    return PaymentResult(
      status: PaymentStatus.success,
      paymentId: paymentId,
      orderId: orderId,
      paymentIntentId: paymentIntentId,
      message: message,
    );
  }

  factory PaymentResult.requiresAction({
    required String clientSecret,
    String? paymentIntentId,
    String? orderId,
    String message = 'Additional authentication required',
  }) {
    return PaymentResult(
      status: PaymentStatus.requiresAction,
      clientSecret: clientSecret,
      paymentIntentId: paymentIntentId,
      orderId: orderId,
      message: message,
    );
  }

  factory PaymentResult.failed({
    String? orderId,
    String? error,
    String message = 'Payment failed',
  }) {
    return PaymentResult(
      status: PaymentStatus.failed,
      orderId: orderId,
      error: error,
      message: message,
    );
  }

  factory PaymentResult.processing({
    String? orderId,
    String message = 'Payment processing',
  }) {
    return PaymentResult(
      status: PaymentStatus.processing,
      orderId: orderId,
      message: message,
    );
  }

  bool get isSuccess => status == PaymentStatus.success;
  bool get isRequiresAction => status == PaymentStatus.requiresAction;
  bool get isFailed => status == PaymentStatus.failed;
  bool get isProcessing => status == PaymentStatus.processing;

  @override
  String toString() {
    return 'PaymentResult(status: $status, message: $message, paymentId: $paymentId, orderId: $orderId)';
  }
}
