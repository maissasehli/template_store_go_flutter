import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cardNumberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _cardholderNameFocus = FocusNode();

  // Card will always be saved in this version, so we don't need this flag anymore
  bool _setAsDefault = false;

  final PaymentController _paymentController = Get.find<PaymentController>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    _emailController.dispose();
    _cardNumberFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
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
          padding: const EdgeInsets.only(top: 16.0 ,right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Number Field
              _buildCardNumberField(),
              const SizedBox(height: 16),

              // CVV and Expiry Date in a row
              Row(
                children: [
                  Expanded(child: _buildCvvField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildExpiryField()),
                ],
              ),
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

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cardNumberController,
          focusNode: _cardNumberFocus,
          keyboardType: TextInputType.number,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inputForeground(context),
                ) ??
                const TextStyle(),
          ),
          decoration: _buildInputDecoration('payment.card_number'.translate()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(19),
            _CardNumberInputFormatter(),
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.card_number_required'.translate();
            }
            if (!_paymentController.validateCardNumber(
              value!.replaceAll(' ', ''),
            )) {
              return 'payment.form_validation.invalid_card_format'.translate();
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_cvvFocus);
          },
        ),
      ],
    );
  }

  Widget _buildCvvField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cvvController,
          focusNode: _cvvFocus,
          keyboardType: TextInputType.number,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inputForeground(context),
                ) ??
                const TextStyle(),
          ),
          decoration: _buildInputDecoration('payment.cvv'.translate()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.cvv_required'.translate();
            }
            if (!_paymentController.validateCVC(value!)) {
              return 'payment.form_validation.invalid_cvv_format'.translate();
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_expiryFocus);
          },
        ),
      ],
    );
  }

  Widget _buildExpiryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _expiryController,
          focusNode: _expiryFocus,
          keyboardType: TextInputType.number,
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inputForeground(context),
                ) ??
                const TextStyle(),
          ),
          decoration: _buildInputDecoration('payment.expiry_date'.translate()),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            _ExpiryDateInputFormatter(),
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.expiry_required'.translate();
            }
            if (!_paymentController.validateExpiryDate(value!)) {
              return 'payment.form_validation.invalid_expiry_format'
                  .translate();
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_cardholderNameFocus);
          },
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

    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text;
    final expiryParts = expiry.split('/');
    final expiryMonth = int.parse(expiryParts[0]);
    final expiryYear = int.parse('20${expiryParts[1]}');
    final cvv = _cvvController.text;
    final cardholderName = _cardholderNameController.text;
    // We don't have an email field in the simplified UI, so we'll pass null
    final email = null;

    final success = await _paymentController.createAndSavePaymentMethod(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvc: cvv,
      cardholderName: cardholderName,
      email: email,
      setAsDefault: _setAsDefault, // Default to false
    );

    if (success) {
      Get.back();
    }
  }
}

// Input formatters
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length <= 2) {
      return newValue;
    }

    final month = text.substring(0, 2);
    final year = text.substring(2);

    return TextEditingValue(
      text: '$month/$year',
      selection: TextSelection.collapsed(offset: '$month/$year'.length),
    );
  }
}
