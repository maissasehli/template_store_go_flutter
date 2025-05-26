import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:store_go/features/checkout/controllers/checkout_controller.dart';
import 'package:store_go/features/payment/services/payment_service.dart';
import 'package:store_go/features/order/repositories/order_repository.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';
import 'package:store_go/features/payment/models/payment_method_model.dart';

// Generate mocks
@GenerateMocks([PaymentService, OrderRepository])
import 'checkout_controller_test.mocks.dart';

void main() {
  group('CheckoutController', () {
    late CheckoutController checkoutController;
    late MockPaymentService mockPaymentService;
    late MockOrderRepository mockOrderRepository;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Create mocks
      mockPaymentService = MockPaymentService();
      mockOrderRepository = MockOrderRepository();

      // Register mocks with GetX
      Get.put<PaymentService>(mockPaymentService);
      Get.put<OrderRepository>(mockOrderRepository);

      // Create controller
      checkoutController = CheckoutController();
    });

    tearDown(() {
      Get.reset();
    });

    group('Order Creation', () {
      test('should create order successfully', () async {
        const orderId = 'order_123';
        final cartItems = [
          CartItem(
            id: '1',
            productId: 'prod_1',
            name: 'Test Product',
            price: 25.99,
            quantity: 2,
            imageUrl: 'test.jpg',
            size: 'M',
            color: 'Blue',
          ),
        ];

        when(
          mockOrderRepository.createOrder(any),
        ).thenAnswer((_) async => orderId);

        final result = await checkoutController.createOrder(
          cartItems: cartItems,
          subtotal: 51.98,
          tax: 4.16,
          shippingCost: 5.00,
          discount: 0.00,
          total: 61.14,
        );

        expect(result, equals(orderId));
        verify(mockOrderRepository.createOrder(any)).called(1);
      });

      test('should handle order creation failure', () async {
        final cartItems = [
          CartItem(
            id: '1',
            productId: 'prod_1',
            name: 'Test Product',
            price: 25.99,
            quantity: 2,
            imageUrl: 'test.jpg',
            size: 'M',
            color: 'Blue',
          ),
        ];

        when(
          mockOrderRepository.createOrder(any),
        ).thenThrow(Exception('Order creation failed'));

        expect(
          () => checkoutController.createOrder(
            cartItems: cartItems,
            subtotal: 51.98,
            tax: 4.16,
            shippingCost: 5.00,
            discount: 0.00,
            total: 61.14,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Payment Processing', () {
      test('should process payment for order successfully', () async {
        const orderId = 'order_123';
        const total = 61.14;
        final cardDetails = {
          'cardNumber': '4242424242424242',
          'expiryMonth': 12,
          'expiryYear': 2025,
          'cvc': '123',
          'cardholderName': 'John Doe',
        };

        final paymentMethod = PaymentMethod(
          id: 'pm_123',
          customerId: 'cus_123',
          last4: '4242',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        final expectedResult = PaymentResult.success(
          orderId: orderId,
          paymentIntentId: 'pi_123',
          message: 'Payment successful',
        );

        when(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => paymentMethod);

        when(
          mockPaymentService.processPayment(
            orderId: anyNamed('orderId'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            savePaymentMethod: anyNamed('savePaymentMethod'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await checkoutController.processPaymentForOrder(
          orderId: orderId,
          total: total,
          cardDetails: cardDetails,
          savePaymentMethod: false,
        );

        expect(result, equals(expectedResult));
        expect(result.isSuccess, isTrue);
        verify(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: '4242424242424242',
            expiryMonth: 12,
            expiryYear: 2025,
            cvc: '123',
            cardholderName: 'John Doe',
            setAsDefault: false,
          ),
        ).called(1);
        verify(
          mockPaymentService.processPayment(
            orderId: orderId,
            amount: total,
            currency: 'USD',
            paymentMethodId: 'pm_123',
            savePaymentMethod: false,
          ),
        ).called(1);
      });

      test('should handle payment processing failure', () async {
        const orderId = 'order_123';
        const total = 61.14;
        final cardDetails = {
          'cardNumber': '4000000000000002',
          'expiryMonth': 12,
          'expiryYear': 2025,
          'cvc': '123',
          'cardholderName': 'John Doe',
        };

        final paymentMethod = PaymentMethod(
          id: 'pm_declined',
          customerId: 'cus_123',
          last4: '0002',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        final expectedResult = PaymentResult.failed(
          orderId: orderId,
          error: 'Card declined',
          message: 'Your card was declined',
        );

        when(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => paymentMethod);

        when(
          mockPaymentService.processPayment(
            orderId: anyNamed('orderId'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            savePaymentMethod: anyNamed('savePaymentMethod'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await checkoutController.processPaymentForOrder(
          orderId: orderId,
          total: total,
          cardDetails: cardDetails,
          savePaymentMethod: false,
        );

        expect(result.isFailed, isTrue);
        expect(result.error, equals('Card declined'));
      });

      test('should handle 3D Secure requirement', () async {
        const orderId = 'order_123';
        const total = 61.14;
        final cardDetails = {
          'cardNumber': '4000002500003155',
          'expiryMonth': 12,
          'expiryYear': 2025,
          'cvc': '123',
          'cardholderName': 'John Doe',
        };

        final paymentMethod = PaymentMethod(
          id: 'pm_3ds',
          customerId: 'cus_123',
          last4: '3155',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        final expectedResult = PaymentResult.requiresAction(
          orderId: orderId,
          clientSecret: 'pi_123_secret_123',
          paymentIntentId: 'pi_123',
          message: '3D Secure authentication required',
        );

        when(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => paymentMethod);

        when(
          mockPaymentService.processPayment(
            orderId: anyNamed('orderId'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            savePaymentMethod: anyNamed('savePaymentMethod'),
          ),
        ).thenAnswer((_) async => expectedResult);

        final result = await checkoutController.processPaymentForOrder(
          orderId: orderId,
          total: total,
          cardDetails: cardDetails,
          savePaymentMethod: false,
        );

        expect(result.isRequiresAction, isTrue);
        expect(result.clientSecret, isNotNull);
        expect(result.paymentIntentId, isNotNull);
      });
    });

    group('3D Secure Authentication', () {
      test('should handle 3D Secure authentication successfully', () async {
        final paymentResult = PaymentResult.requiresAction(
          orderId: 'order_123',
          clientSecret: 'pi_123_secret_123',
          paymentIntentId: 'pi_123',
          message: '3D Secure authentication required',
        );

        final expectedResult = PaymentResult.success(
          orderId: 'order_123',
          paymentIntentId: 'pi_123',
          message: 'Authentication successful',
        );

        when(
          mockPaymentService.handle3DSecure(
            clientSecret: anyNamed('clientSecret'),
          ),
        ).thenAnswer((_) async => expectedResult);

        await checkoutController.handle3DSecure(paymentResult);

        verify(
          mockPaymentService.handle3DSecure(clientSecret: 'pi_123_secret_123'),
        ).called(1);
      });

      test('should handle invalid 3D Secure parameters', () async {
        final paymentResult = PaymentResult.failed(
          orderId: 'order_123',
          error: 'Invalid parameters',
          message: 'Missing client secret',
        );

        expect(
          () => checkoutController.handle3DSecure(paymentResult),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Complete Checkout Flow', () {
      test('should complete entire checkout flow successfully', () async {
        const orderId = 'order_123';
        final cartItems = [
          CartItem(
            id: '1',
            productId: 'prod_1',
            name: 'Test Product',
            price: 25.99,
            quantity: 2,
            imageUrl: 'test.jpg',
            size: 'M',
            color: 'Blue',
          ),
        ];
        final cardDetails = {
          'cardNumber': '4242424242424242',
          'expiryMonth': 12,
          'expiryYear': 2025,
          'cvc': '123',
          'cardholderName': 'John Doe',
        };

        final paymentMethod = PaymentMethod(
          id: 'pm_123',
          customerId: 'cus_123',
          last4: '4242',
          brand: 'visa',
          expiryMonth: 12,
          expiryYear: 2025,
        );

        final paymentResult = PaymentResult.success(
          orderId: orderId,
          paymentIntentId: 'pi_123',
          message: 'Payment successful',
        );

        // Mock order creation
        when(
          mockOrderRepository.createOrder(any),
        ).thenAnswer((_) async => orderId);

        // Mock payment method creation
        when(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: anyNamed('cardNumber'),
            expiryMonth: anyNamed('expiryMonth'),
            expiryYear: anyNamed('expiryYear'),
            cvc: anyNamed('cvc'),
            cardholderName: anyNamed('cardholderName'),
            setAsDefault: anyNamed('setAsDefault'),
          ),
        ).thenAnswer((_) async => paymentMethod);

        // Mock payment processing
        when(
          mockPaymentService.processPayment(
            orderId: anyNamed('orderId'),
            amount: anyNamed('amount'),
            currency: anyNamed('currency'),
            paymentMethodId: anyNamed('paymentMethodId'),
            savePaymentMethod: anyNamed('savePaymentMethod'),
          ),
        ).thenAnswer((_) async => paymentResult);

        // Execute complete checkout flow
        final result = await checkoutController.completeCheckout(
          cartItems: cartItems,
          subtotal: 51.98,
          tax: 4.16,
          shippingCost: 5.00,
          discount: 0.00,
          total: 61.14,
          cardDetails: cardDetails,
          savePaymentMethod: false,
        );

        expect(result, equals(orderId));
        verify(mockOrderRepository.createOrder(any)).called(1);
        verify(
          mockPaymentService.createAndSavePaymentMethod(
            cardNumber: '4242424242424242',
            expiryMonth: 12,
            expiryYear: 2025,
            cvc: '123',
            cardholderName: 'John Doe',
            setAsDefault: false,
          ),
        ).called(1);
        verify(
          mockPaymentService.processPayment(
            orderId: orderId,
            amount: 61.14,
            currency: 'USD',
            paymentMethodId: 'pm_123',
            savePaymentMethod: false,
          ),
        ).called(1);
      });
    });
  });
}
