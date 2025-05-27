import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/checkout/controllers/checkout_controller.dart';
import 'package:store_go/features/payment/view/widget/payment_card_form.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({Key? key}) : super(key: key);

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  final CartController cartController = Get.find<CartController>();
  final CheckoutController checkoutController = Get.find<CheckoutController>();

  Map<String, dynamic>? _cardDetails;
  bool _savePaymentMethod = false;
  bool _isProcessing = false;

  // Arguments from navigation
  late String orderId;
  late double amount;
  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    _initializeArguments();
  }

  void _initializeArguments() {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    orderId = arguments['orderId'] ?? '';
    amount = arguments['amount'] ?? cartController.total.value;
    cartItems = arguments['cartItems'] ?? cartController.cartItems;
    if (orderId.isEmpty) {
      Get.snackbar(
        'Error'.translate(),
        'Invalid order information'.translate(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'payment.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary card
            _buildOrderSummaryCard(),

            SizedBox(height: 24),

            // Payment form
            PaymentCardForm(
              onCardChanged: (cardDetails) {
                setState(() {
                  _cardDetails = cardDetails;
                });
              },
              enabled: !_isProcessing,
            ),

            SizedBox(height: 16),

            // Save payment method option
            Row(
              children: [
                Checkbox(
                  value: _savePaymentMethod,
                  onChanged:
                      _isProcessing
                          ? null
                          : (value) {
                            setState(() {
                              _savePaymentMethod = value ?? false;
                            });
                          },
                  activeColor: AppColors.primary(context),
                ),
                Expanded(
                  child: Text(
                    'payment.save_card'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: 14,
                        color: AppColors.foreground(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24), // Payment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canProcessPayment() ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: AppColors.primaryForeground(context),
                  disabledBackgroundColor: AppColors.muted(context),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isProcessing
                        ? CircularProgressIndicator(
                          color: AppColors.primaryForeground(context),
                          strokeWidth: 2,
                        )
                        : Text(
                          '${'payment.processing_payment'.translate()} \$${amount.toStringAsFixed(2)}',
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              ),
            ),

            SizedBox(height: 16), // Security notice
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 4),
                Text(
                  'payment.secure_payment'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout.order_summary'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground(context),
              ),
            ),
          ),
          SizedBox(height: 12),
          _buildSummaryRow(
            'checkout.subtotal'.translate(),
            '\$${cartController.subtotal.value.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'checkout.shipping_cost'.translate(),
            '\$${cartController.shipping.value.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'checkout.tax'.translate(),
            '\$${cartController.tax.value.toStringAsFixed(2)}',
          ),
          if (cartController.discount.value > 0)
            _buildSummaryRow(
              'checkout.discount'.translate(),
              '-\$${cartController.discount.value.toStringAsFixed(2)}',
              color: Colors.green,
            ),

          Divider(height: 24),

          _buildSummaryRow(
            'checkout.total'.translate(),
            '\$${cartController.total.value.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                color: color ?? AppColors.foreground(context),
              ),
            ),
          ),
          Text(
            value,
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                color: color ?? AppColors.foreground(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProcessPayment() {
    return !_isProcessing &&
        _cardDetails != null &&
        (_cardDetails!['complete'] ?? false);
  }

  Future<void> _processPayment() async {
    if (!_canProcessPayment()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Process payment using the orderId from arguments
      final paymentResult = await checkoutController.processPaymentForOrder(
        orderId: orderId,
        total: amount,
        cardDetails: _cardDetails!,
        savePaymentMethod: _savePaymentMethod,
      );

      if (paymentResult.isSuccess) {
        // Navigate to order confirmation screen
        Get.offNamed(
          '/order-confirmation',
          arguments: {
            'orderId': orderId,
            'amount': amount,
            'cartItems': cartItems,
          },
        );

        // Clear the cart after successful payment
        await cartController.clearCart();
      } else if (paymentResult.isRequiresAction) {
        // Handle 3D Secure authentication
        await checkoutController.handle3DSecure(paymentResult);
      } else {
        // Navigate to order failure screen
        Get.offNamed(
          '/order-failure',
          arguments: {
            'orderId': orderId,
            'amount': amount,
            'error': paymentResult.message,
          },
        );
      }
    } catch (e) {
      // Navigate to order failure screen with error details
      Get.offNamed(
        '/order-failure',
        arguments: {
          'orderId': orderId,
          'amount': amount,
          'error': e.toString(),
        },
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
