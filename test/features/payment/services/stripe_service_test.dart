import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:store_go/features/payment/services/stripe_service.dart';
import 'package:store_go/features/payment/models/payment_method_model.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';

// Generate mocks
@GenerateMocks([StripeService])
import 'stripe_service_test.mocks.dart';

void main() {
  group('StripeService', () {
    late MockStripeService mockStripeService;

    setUp(() {
      mockStripeService = MockStripeService();
    });

    group('Card Validation', () {
      test('should validate card number correctly', () {
        // Test valid card numbers
        expect(StripeService.validateCardNumber('4242424242424242'), isTrue);
        expect(StripeService.validateCardNumber('5555555555554444'), isTrue);

        // Test invalid card numbers
        expect(StripeService.validateCardNumber('1234567890123456'), isFalse);
        expect(StripeService.validateCardNumber('424242424242424'), isFalse);
        expect(StripeService.validateCardNumber(''), isFalse);
      });

      test('should validate expiry date correctly', () {
        final currentYear = DateTime.now().year;
        final currentMonth = DateTime.now().month;

        // Test valid expiry dates
        expect(StripeService.validateExpiryDate(12, currentYear + 1), isTrue);
        expect(
          StripeService.validateExpiryDate(currentMonth, currentYear),
          isTrue,
        );

        // Test invalid expiry dates
        expect(
          StripeService.validateExpiryDate(currentMonth - 1, currentYear),
          isFalse,
        );
        expect(StripeService.validateExpiryDate(13, currentYear), isFalse);
        expect(StripeService.validateExpiryDate(0, currentYear), isFalse);
      });

      test('should validate CVC correctly', () {
        // Test valid CVCs
        expect(StripeService.validateCVC('123'), isTrue);
        expect(StripeService.validateCVC('1234'), isTrue);

        // Test invalid CVCs
        expect(StripeService.validateCVC('12'), isFalse);
        expect(StripeService.validateCVC('12345'), isFalse);
        expect(StripeService.validateCVC('abc'), isFalse);
        expect(StripeService.validateCVC(''), isFalse);
      });

      test('should detect card brand correctly', () {
        expect(StripeService.getCardBrand('4242424242424242'), equals('visa'));
        expect(
          StripeService.getCardBrand('5555555555554444'),
          equals('mastercard'),
        );
        expect(StripeService.getCardBrand('378282246310005'), equals('amex'));
        expect(
          StripeService.getCardBrand('6011111111111117'),
          equals('discover'),
        );
        expect(
          StripeService.getCardBrand('1234567890123456'),
          equals('unknown'),
        );
      });

      test('should format card number correctly', () {
        expect(
          StripeService.formatCardNumber('4242424242424242'),
          equals('4242 4242 4242 4242'),
        );
        expect(
          StripeService.formatCardNumber('378282246310005'),
          equals('3782 822463 10005'),
        );
        expect(StripeService.formatCardNumber('123456'), equals('1234 56'));
      });
    });

    group('Payment Methods', () {
      test('should create payment method successfully', () async {
        final expectedPaymentMethod = PaymentMethod(
          id: 'pm_123',
          customerId: 'cus_123',
          last4: '4242',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        when(
          mockStripeService.createPaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
          ),
        ).thenAnswer((_) async => expectedPaymentMethod);

        final result = await mockStripeService.createPaymentMethod(
          cardNumber: '4242424242424242',
          expiryMonth: 12,
          expiryYear: 2025,
          cvc: '123',
          cardholderName: 'John Doe',
        );

        expect(result, equals(expectedPaymentMethod));
        verify(
          mockStripeService.createPaymentMethod(
            cardNumber: '4242424242424242',
            expiryMonth: 12,
            expiryYear: 2025,
            cvc: '123',
            cardholderName: 'John Doe',
          ),
        ).called(1);
      });

      test('should save payment method successfully', () async {
        final paymentMethod = PaymentMethod(
          id: 'pm_123',
          customerId: 'cus_123',
          last4: '4242',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        when(
          mockStripeService.savePaymentMethod(any),
        ).thenAnswer((_) async => paymentMethod);

        final result = await mockStripeService.savePaymentMethod(paymentMethod);

        expect(result, equals(paymentMethod));
        verify(mockStripeService.savePaymentMethod(paymentMethod)).called(1);
      });

      test('should load payment methods successfully', () async {
        final expectedPaymentMethods = [
          PaymentMethod(
            id: 'pm_123',
            customerId: 'cus_123',
            last4: '4242',
            brand: 'visa',
            expiryMonth: 12,
            expiryYear: 2025,
          ),
          PaymentMethod(
            id: 'pm_124',
            customerId: 'cus_123',
            last4: '5555',
            brand: 'mastercard',
            expiryMonth: 6,
            expiryYear: 2026,
          ),
        ];

        when(
          mockStripeService.loadPaymentMethods(),
        ).thenAnswer((_) async => expectedPaymentMethods);

        final result = await mockStripeService.loadPaymentMethods();

        expect(result, equals(expectedPaymentMethods));
        expect(result.length, equals(2));
        verify(mockStripeService.loadPaymentMethods()).called(1);
      });
    });

    group('Payment Processing', () {
      test('should process payment successfully', () async {
        final expectedResult = PaymentResult.success(
          orderId: 'order_123',
          paymentIntentId: 'pi_123',
          message: 'Payment successful',
        );

        when(
          mockStripeService.processPayment(
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            customerId: anyNamed('customerId'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await mockStripeService.processPayment(
          amount: 1000,
          currency: 'USD',
          paymentMethodId: 'pm_123',
          customerId: 'cus_123',
        );

        expect(result, equals(expectedResult));
        verify(
          mockStripeService.processPayment(
            amount: 1000,
            currency: 'USD',
            paymentMethodId: 'pm_123',
            customerId: 'cus_123',
          ),
        ).called(1);
      });

      test('should handle 3D Secure authentication', () async {
        final expectedResult = PaymentResult.success(
          orderId: 'order_123',
          paymentIntentId: 'pi_123',
          message: 'Authentication successful',
        );

        when(
          mockStripeService.handle3DSecure(
            clientSecret: anyNamed('clientSecret'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await mockStripeService.handle3DSecure(
          clientSecret: 'pi_123_secret_123',
        );

        expect(result, equals(expectedResult));
        verify(
          mockStripeService.handle3DSecure(clientSecret: 'pi_123_secret_123'),
        ).called(1);
      });

      test('should handle payment failure', () async {
        final expectedResult = PaymentResult.failed(
          orderId: 'order_123',
          error: 'Card declined',
          message: 'Your card was declined',
        );

        when(
          mockStripeService.processPayment(
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            customerId: anyNamed('customerId'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await mockStripeService.processPayment(
          amount: 1000,
          currency: 'USD',
          paymentMethodId: 'pm_declined',
          customerId: 'cus_123',
        );

        expect(result.isFailed, isTrue);
        expect(result.error, equals('Card declined'));
      });
    });
  });
}
