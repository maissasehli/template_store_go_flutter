import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/shared/extensions/text_extensions.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/features/checkout/controllers/checkout_controller.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import 'package:store_go/features/payment/models/payment_result_model.dart';
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

  /// Check if using saved payment method
  bool get _usingSavedPaymentMethod {
    return Get.isRegistered<PaymentController>() &&
        Get.find<PaymentController>().selectedPaymentMethod.value != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath:
                LocalizationService.isRtl(context)
                    ? AssetConfig.arrowRight
                    : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('payment.processing_payment'.translate()).heading5(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(UIConfig.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary card
            _buildOrderSummaryCard(),
            SizedBox(height: 24),

            // Show saved payment method info or payment form
            if (_usingSavedPaymentMethod) ...[
              _buildSavedPaymentMethodInfo(),
            ] else ...[
              PaymentCardForm(
                onCardChanged: (cardDetails) {
                  setState(() {
                    _cardDetails = cardDetails;
                  });
                },
                enabled: !_isProcessing,
              ),
              SizedBox(height: UIConfig.marginMedium),
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
                    child: Text('payment.save_card'.translate()).body(context),
                  ),
                ],
              ),
            ],

            SizedBox(height: UIConfig.marginXLarge), // Payment button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _canProcessPayment() ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: AppColors.primaryForeground(context),
                  disabledBackgroundColor: AppColors.muted(context),
                  padding: EdgeInsets.symmetric(
                    vertical: UIConfig.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppTheme.globalButtonsRadius,
                    ),
                  ),
                ),
                child:
                    _isProcessing
                        ? CircularProgressIndicator(
                          color: AppColors.background(context),
                          strokeWidth: 2,
                        )
                        : Text(
                          '${'payment.pay'.translate()} \$${amount.toStringAsFixed(2)}',
                          style: LocalizationService.getLocalizedTextStyle(context, 
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryForeground(context),
                            ),
                          ),
                        ),
              ),
            ),
            SizedBox(height: UIConfig.marginMedium), // Security notice
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 16,
                  color: AppColors.mutedForeground(context),
                ),
                SizedBox(width: 4),
                Text('payment.secure_payment'.translate()).caption(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: EdgeInsets.all(UIConfig.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(AppTheme.globalRadius),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment.order_summary'.translate()).heading5(context),
          SizedBox(height: UIConfig.marginMedium),
          _buildSummaryRow(
            'payment.subtotal'.translate(),
            '\$${cartController.subtotal.value.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'payment.shipping_cost'.translate(),
            '\$${cartController.shipping.value.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'payment.tax'.translate(),
            '\$${cartController.tax.value.toStringAsFixed(2)}',
          ),
          if (cartController.discount.value > 0)
            _buildSummaryRow(
              'payment.discount'.translate(),
              '-\$${cartController.discount.value.toStringAsFixed(2)}',
              color: Colors.green,
            ),

          Divider(height: 24),

          _buildSummaryRow(
            'payment.total'.translate(),
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
          Expanded(
            child:
                isTotal
                    ? Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color ?? AppColors.foreground(context),
                      ),
                    ).heading5(context)
                    : Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: color ?? AppColors.foreground(context),
                      ),
                    ).body(context),
          ),
          isTotal
              ? Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color ?? AppColors.foreground(context),
                ),
              ).heading5(context)
              : Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: color ?? AppColors.foreground(context),
                ),
              ).body(context),
        ],
      ),
    );
  }

  bool _canProcessPayment() {
    if (_isProcessing) return false;

    if (_usingSavedPaymentMethod) {
      // For saved payment methods, just need to ensure we have a selected method
      return Get.isRegistered<PaymentController>() &&
          Get.find<PaymentController>().selectedPaymentMethod.value != null;
    } else {
      // For new cards, need valid card details
      return _cardDetails != null && (_cardDetails!['complete'] ?? false);
    }
  }

  Future<void> _processPayment() async {
    if (!_canProcessPayment()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      PaymentResult paymentResult;

      if (_usingSavedPaymentMethod) {
        // Use saved payment method
        final paymentController = Get.find<PaymentController>();
        final selectedMethod = paymentController.selectedPaymentMethod.value!;

        print('Processing payment with saved method: ${selectedMethod.id}');
        print(
          'Stripe payment method ID: ${selectedMethod.stripePaymentMethodId}',
        );

        paymentResult = await checkoutController.processPaymentWithSavedMethod(
          orderId: orderId,
          total: amount,
          paymentMethodId: selectedMethod.stripePaymentMethodId!,
        );
      } else {
        // Use new card details
        print('Processing payment with new card details');
        paymentResult = await checkoutController.processPaymentForOrder(
          orderId: orderId,
          total: amount,
          cardDetails: _cardDetails!,
          savePaymentMethod: _savePaymentMethod,
        );
      }

      // Handle payment result (same for both flows)
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
        // Payment failed - show user-friendly error message
        String errorMessage = paymentResult.message;
        // Handle specific PaymentMethod reuse error
        if (paymentResult.error != null &&
            (paymentResult.error!.contains(
                  'PaymentMethod was previously used',
                ) ||
                paymentResult.error!.contains('may not be used again'))) {
          errorMessage = 'payment.payment_method_reused'.translate();

          // Clear the card details to force user to re-enter them
          setState(() {
            _cardDetails = null;
          });
        }

        Get.snackbar(
          'payment.payment_failed'.translate(),
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );

        // Don't navigate away - let user try again with fresh card details
        print('Payment failed: ${paymentResult.message}');
      }
    } catch (e) {
      print('Error processing payment: $e');
      String errorMessage = 'payment.processing_failed'.translate();
      // Handle specific PaymentMethod reuse error
      if (e.toString().contains('PaymentMethod was previously used') ||
          e.toString().contains('may not be used again')) {
        errorMessage = 'payment.payment_method_reused'.translate();

        // Clear the card details to force user to re-enter them
        setState(() {
          _cardDetails = null;
        });
      }

      Get.snackbar(
        'payment.error'.translate(),
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      // Don't navigate away on this error - let user try again
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _buildSavedPaymentMethodInfo() {
    if (!Get.isRegistered<PaymentController>()) {
      return SizedBox.shrink();
    }

    final paymentController = Get.find<PaymentController>();
    final selectedMethod = paymentController.selectedPaymentMethod.value;

    if (selectedMethod == null) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(UIConfig.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(AppTheme.globalRadius),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment.selected_payment_method'.translate()).heading5(context),
          SizedBox(height: UIConfig.marginMedium),
          Row(
            children: [
              Icon(
                Icons.credit_card,
                size: 24,
                color: AppColors.primary(context),
              ),
              SizedBox(width: UIConfig.marginMedium),
              Text(selectedMethod.displayName).body(context),
            ],
          ),
          if (selectedMethod.isDefault) ...[
            SizedBox(height: 4),
            Row(
              children: [
                SizedBox(width: 36), // Align with card icon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.globalRadius),
                  ),
                  child: Text('payment.default'.translate()).caption(context),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
