import 'package:flutter_test/flutter_test.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';

void main() {
  group('PaymentResult', () {
    test('should create successful payment result', () {
      const orderId = 'order_123';
      const paymentIntentId = 'pi_123';
      const message = 'Payment successful';

      final result = PaymentResult.success(
        orderId: orderId,
        paymentIntentId: paymentIntentId,
        message: message,
      );

      expect(result.orderId, equals(orderId));
      expect(result.paymentIntentId, equals(paymentIntentId));
      expect(result.message, equals(message));
      expect(result.isSuccess, isTrue);
      expect(result.isRequiresAction, isFalse);
      expect(result.isFailed, isFalse);
      expect(result.error, isNull);
      expect(result.clientSecret, isNull);
    });

    test('should create failed payment result', () {
      const orderId = 'order_123';
      const error = 'Payment failed';
      const message = 'Card declined';

      final result = PaymentResult.failed(
        orderId: orderId,
        error: error,
        message: message,
      );

      expect(result.orderId, equals(orderId));
      expect(result.error, equals(error));
      expect(result.message, equals(message));
      expect(result.isSuccess, isFalse);
      expect(result.isRequiresAction, isFalse);
      expect(result.isFailed, isTrue);
      expect(result.paymentIntentId, isNull);
      expect(result.clientSecret, isNull);
    });

    test('should create requires action payment result', () {
      const orderId = 'order_123';
      const clientSecret = 'pi_123_secret';
      const paymentIntentId = 'pi_123';
      const message = '3D Secure authentication required';

      final result = PaymentResult.requiresAction(
        orderId: orderId,
        clientSecret: clientSecret,
        paymentIntentId: paymentIntentId,
        message: message,
      );

      expect(result.orderId, equals(orderId));
      expect(result.clientSecret, equals(clientSecret));
      expect(result.paymentIntentId, equals(paymentIntentId));
      expect(result.message, equals(message));
      expect(result.isSuccess, isFalse);
      expect(result.isRequiresAction, isTrue);
      expect(result.isFailed, isFalse);
      expect(result.error, isNull);
    });

    test('should convert to and from JSON', () {
      final originalResult = PaymentResult.success(
        orderId: 'order_123',
        paymentIntentId: 'pi_123',
        message: 'Payment successful',
      );

      final json = originalResult.toJson();
      final convertedResult = PaymentResult.fromJson(json);

      expect(convertedResult.orderId, equals(originalResult.orderId));
      expect(
        convertedResult.paymentIntentId,
        equals(originalResult.paymentIntentId),
      );
      expect(convertedResult.message, equals(originalResult.message));
      expect(convertedResult.isSuccess, equals(originalResult.isSuccess));
      expect(
        convertedResult.isRequiresAction,
        equals(originalResult.isRequiresAction),
      );
      expect(convertedResult.isFailed, equals(originalResult.isFailed));
    });

    test('should handle equality correctly', () {
      final result1 = PaymentResult.success(
        orderId: 'order_123',
        paymentIntentId: 'pi_123',
        message: 'Payment successful',
      );

      final result2 = PaymentResult.success(
        orderId: 'order_123',
        paymentIntentId: 'pi_123',
        message: 'Payment successful',
      );

      final result3 = PaymentResult.failed(
        orderId: 'order_123',
        error: 'Failed',
        message: 'Payment failed',
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
  });
}
