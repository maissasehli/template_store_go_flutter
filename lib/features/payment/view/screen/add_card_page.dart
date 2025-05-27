import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import '../../controller/payment_controller.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardholderNameController = TextEditingController();
  final _cardholderNameFocus = FocusNode();

  // Stripe card details from CardField
  CardFieldInputDetails? _cardDetails;
  bool _cardComplete = false;
  bool _isLoading = false;

  final PaymentController _paymentController = Get.find<PaymentController>();
  @override
  void dispose() {
    _cardholderNameController.dispose();
    _cardholderNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
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
        elevation: 0,
        title: Text(
          'payment.add_payment_method'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Secure Stripe Card Field
              _buildSecureCardField(),
              const SizedBox(height: 16),

              // Cardholder Name field
              _buildCardholderNameField(),

              // Spacer to push button to bottom
              const Spacer(),

              // Save Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Obx(() => _buildSaveButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecureCardField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'payment.card_details'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground(context),
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(AppTheme.globalButtonsRadius),
          ),
          child: CardField(
            onCardChanged: (card) {
              setState(() {
                _cardDetails = card;
                _cardComplete = card?.complete ?? false;
              });
            },
            enablePostalCode: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintText: 'payment.enter_card_details'.translate(),
              hintStyle: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  color: AppColors.mutedForeground(context),
                  fontSize: 16,
                ),
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.foreground(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.security,
              size: 16,
              color: AppColors.mutedForeground(context),
            ),
            const SizedBox(width: 4),
            Text(
              'payment.secure_stripe_encryption'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedForeground(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardholderNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cardholderNameController,
          focusNode: _cardholderNameFocus,
          textCapitalization: TextCapitalization.words,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inputForeground(context),
                ) ??
                const TextStyle(),
          ),
          decoration: _buildInputDecoration(
            'payment.cardholder_name'.translate(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.cardholder_required'.translate();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _paymentController.isLoading.value ? null : _handleSaveCard,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(context),
          foregroundColor: AppColors.primaryForeground(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.globalButtonsRadius),
          ),
          disabledBackgroundColor: AppColors.muted(context),
          disabledForegroundColor: AppColors.mutedForeground(context),
        ),
        child:
            _paymentController.isLoading.value
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryForeground(context),
                    ),
                  ),
                )
                : Text(
                  'common.save'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryForeground(context),
                        ) ??
                        const TextStyle(),
                  ),
                ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      filled: true,
      fillColor: AppColors.input(context),
      hintText: hint,
      hintStyle: LocalizationService.getLocalizedTextStyle(
        context,
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedForeground(context),
            ) ??
            const TextStyle(),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary(context), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.destructive(context)),
      ),
      // Make the fields match the screenshot with more padding
      isDense: true,
    );
  }

  Future<void> _handleSaveCard() async {
    if (!_formKey.currentState!.validate()) return;

    if (_cardDetails == null || !_cardComplete) {
      Get.snackbar(
        'common.error'.translate(),
        'payment.form_validation.complete_card_required'.translate(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        colorText: Theme.of(context).colorScheme.onError,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cardholderName = _cardholderNameController.text;

    try {
      final success = await _paymentController
          .createAndSavePaymentMethodFromCardField(
            cardholderName: cardholderName,
            setAsDefault: false,
          );

      if (success) {
        // Navigate back to the previous screen
        Logger().i(
          'Payment method saved successfully, navigating back',
        );
        Get.back();
      }
    } catch (e) {
      // show logger error and not snackbar
      Logger().e(
        'Error saving payment method: $e',
        e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
