import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/payment/repositories/payment_repository.dart';
import 'package:store_go/features/payment/services/stripe_service.dart';
import 'package:store_go/features/payment/models/payment_method_model.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';

// Generate mocks
@GenerateMocks([PaymentRepository, StripeService])
import 'payment_service_test.mocks.dart';

void main() {
  group('PaymentService', () {
    late PaymentService paymentService;
    late MockPaymentRepository mockPaymentRepository;
    late MockStripeService mockStripeService;

    setUp(() {
      mockPaymentRepository = MockPaymentRepository();
      mockStripeService = MockStripeService();
      paymentService = PaymentService(mockPaymentRepository, mockStripeService);
    });

    group('Payment Methods', () {
      test('should create and save payment method successfully', () async {
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

        when(
          mockPaymentRepository.savePaymentMethod(any),
        ).thenAnswer((_) async => expectedPaymentMethod);

        final result = await paymentService.createAndSavePaymentMethod(
          cardNumber: '4242424242424242',
          expiryMonth: 12,
          expiryYear: 2025,
          cvc: '123',
          cardholderName: 'John Doe',
          setAsDefault: true,
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
        verify(
          mockPaymentRepository.savePaymentMethod(expectedPaymentMethod),
        ).called(1);
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
            isDefault: true,
          ),
          PaymentMethod(
            id: 'pm_124',
            customerId: 'cus_123',
            last4: '5555',
            brand: 'mastercard',
            expiryMonth: 6,
            expiryYear: 2026,
            isDefault: false,
          ),
        ];

        when(
          mockPaymentRepository.getPaymentMethods(),
        ).thenAnswer((_) async => expectedPaymentMethods);

        final result = await paymentService.getPaymentMethods();

        expect(result, equals(expectedPaymentMethods));
        expect(result.length, equals(2));
        expect(result.first.isDefault, isTrue);
        verify(mockPaymentRepository.getPaymentMethods()).called(1);
      });

      test('should delete payment method successfully', () async {
        const paymentMethodId = 'pm_123';

        when(
          mockPaymentRepository.deletePaymentMethod(paymentMethodId),
        ).thenAnswer((_) async {});

        await paymentService.deletePaymentMethod(paymentMethodId);

        verify(
          mockPaymentRepository.deletePaymentMethod(paymentMethodId),
        ).called(1);
      });

      test('should set default payment method successfully', () async {
        const paymentMethodId = 'pm_123';

        when(
          mockPaymentRepository.setDefaultPaymentMethod(paymentMethodId),
        ).thenAnswer((_) async {});

        await paymentService.setDefaultPaymentMethod(paymentMethodId);

        verify(
          mockPaymentRepository.setDefaultPaymentMethod(paymentMethodId),
        ).called(1);
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

        final result = await paymentService.processPayment(
          orderId: 'order_123',
          amount: 1000,
          currency: 'USD',
          paymentMethodId: 'pm_123',
          savePaymentMethod: false,
        );

        expect(result, equals(expectedResult));
        verify(
          mockStripeService.processPayment(
            amount: 1000,
            currency: 'USD',
            paymentMethodId: 'pm_123',
            customerId: anyNamed('customerId'),
          ),
        ).called(1);
      });

      test('should handle 3D Secure authentication successfully', () async {
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

        final result = await paymentService.handle3DSecure(
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

        final result = await paymentService.processPayment(
          orderId: 'order_123',
          amount: 1000,
          currency: 'USD',
          paymentMethodId: 'pm_declined',
          savePaymentMethod: false,
        );

        expect(result.isFailed, isTrue);
        expect(result.error, equals('Card declined'));
      });

      test('should save payment method when requested', () async {
        final paymentMethod = PaymentMethod(
          id: 'pm_123',
          customerId: 'cus_123',
          last4: '4242',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

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

        when(
          mockPaymentRepository.getPaymentMethodById('pm_123'),
        ).thenAnswer((_) async => paymentMethod);

        when(
          mockPaymentRepository.savePaymentMethod(any),
        ).thenAnswer((_) async => paymentMethod);

        final result = await paymentService.processPayment(
          orderId: 'order_123',
          amount: 1000,
          currency: 'USD',
          paymentMethodId: 'pm_123',
          savePaymentMethod: true,
        );

        expect(result.isSuccess, isTrue);
        verify(mockPaymentRepository.savePaymentMethod(any)).called(1);
      });
    });

    group('Payment History', () {
      test('should get payment history successfully', () async {
        final expectedHistory = [
          PaymentResult.success(
            orderId: 'order_123',
            paymentIntentId: 'pi_123',
            message: 'Payment successful',
          ),
          PaymentResult.failed(
            orderId: 'order_124',
            error: 'Card declined',
            message: 'Payment failed',
          ),
        ];

        when(
          mockPaymentRepository.getPaymentHistory(),
        ).thenAnswer((_) async => expectedHistory);

        final result = await paymentService.getPaymentHistory();

        expect(result, equals(expectedHistory));
        expect(result.length, equals(2));
        verify(mockPaymentRepository.getPaymentHistory()).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle payment method creation error', () async {
        when(
          mockStripeService.createPaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => paymentService.createAndSavePaymentMethod(
            cardNumber: '4242424242424242',
            expiryMonth: 12,
            expiryYear: 2025,
            cvc: '123',
            cardholderName: 'John Doe',
            setAsDefault: false,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle payment processing error', () async {
        when(
          mockStripeService.processPayment(
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            customerId: anyNamed('customerId'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => paymentService.processPayment(
            orderId: 'order_123',
            amount: 1000,
            currency: 'USD',
            paymentMethodId: 'pm_123',
            savePaymentMethod: false,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
