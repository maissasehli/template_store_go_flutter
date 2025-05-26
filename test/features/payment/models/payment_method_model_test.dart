import 'package:flutter_test/flutter_test.dart';
import 'package:store_go/features/payment/models/payment_method_model.dart';

void main() {
  group('PaymentMethod', () {
    test('should create payment method with all fields', () {
      const id = 'pm_123';
      const customerId = 'cus_123';
      const last4 = '4242';
      const brand = 'visa';
      const expiryMonth = 12;
      const expiryYear = 2025;
      const isDefault = true;

      final paymentMethod = PaymentMethod(
        id: id,
        customerId: customerId,
        last4: last4,
        brand: brand,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        isDefault: isDefault,
      );

      expect(paymentMethod.id, equals(id));
      expect(paymentMethod.customerId, equals(customerId));
      expect(paymentMethod.last4, equals(last4));
      expect(paymentMethod.brand, equals(brand));
      expect(paymentMethod.expiryMonth, equals(expiryMonth));
      expect(paymentMethod.expiryYear, equals(expiryYear));
      expect(paymentMethod.isDefault, equals(isDefault));
    });

    test('should format card brand correctly', () {
      final visaCard = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: 12,
        expiryYear: 2025,
      );

      final mastercardCard = PaymentMethod(
        id: 'pm_124',
        customerId: 'cus_123',
        last4: '5555',
        brand: 'mastercard',
        expiryMonth: 12,
        expiryYear: 2025,
      );

      expect(visaCard.formattedBrand, equals('Visa'));
      expect(mastercardCard.formattedBrand, equals('Mastercard'));
    });

    test('should format expiry date correctly', () {
      final paymentMethod = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: 6,
        expiryYear: 2025,
      );

      expect(paymentMethod.expiryDate, equals('06/25'));
    });

    test('should check if card is expired', () {
      final currentYear = DateTime.now().year;
      final currentMonth = DateTime.now().month;

      final expiredCard = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: currentMonth - 1,
        expiryYear: currentYear,
      );

      final validCard = PaymentMethod(
        id: 'pm_124',
        customerId: 'cus_123',
        last4: '5555',
        brand: 'mastercard',
        expiryMonth: 12,
        expiryYear: currentYear + 1,
      );

      expect(expiredCard.isExpired, isTrue);
      expect(validCard.isExpired, isFalse);
    });

    test('should convert to and from JSON', () {
      final originalPaymentMethod = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: 12,
        expiryYear: 2025,
        isDefault: true,
      );

      final json = originalPaymentMethod.toJson();
      final convertedPaymentMethod = PaymentMethod.fromJson(json);

      expect(convertedPaymentMethod.id, equals(originalPaymentMethod.id));
      expect(
        convertedPaymentMethod.customerId,
        equals(originalPaymentMethod.customerId),
      );
      expect(convertedPaymentMethod.last4, equals(originalPaymentMethod.last4));
      expect(convertedPaymentMethod.brand, equals(originalPaymentMethod.brand));
      expect(
        convertedPaymentMethod.expiryMonth,
        equals(originalPaymentMethod.expiryMonth),
      );
      expect(
        convertedPaymentMethod.expiryYear,
        equals(originalPaymentMethod.expiryYear),
      );
      expect(
        convertedPaymentMethod.isDefault,
        equals(originalPaymentMethod.isDefault),
      );
    });

    test('should handle equality correctly', () {
      final paymentMethod1 = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: 12,
        expiryYear: 2025,
      );

      final paymentMethod2 = PaymentMethod(
        id: 'pm_123',
        customerId: 'cus_123',
        last4: '4242',
        brand: 'visa',
        expiryMonth: 12,
        expiryYear: 2025,
      );

      final paymentMethod3 = PaymentMethod(
        id: 'pm_124',
        customerId: 'cus_123',
        last4: '5555',
        brand: 'mastercard',
        expiryMonth: 6,
        expiryYear: 2026,
      );

      expect(paymentMethod1, equals(paymentMethod2));
      expect(paymentMethod1, isNot(equals(paymentMethod3)));
    });
  });
}
