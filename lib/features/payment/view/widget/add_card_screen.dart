import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import '../../controller/payment_controller.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
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

  bool _saveCard = true;
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: ThemeAwareSvg(
              assetPath: AssetConfig.backArrow,
              height: 24,
              width: 24,
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'payment.add_payment_method'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ) ??
                  const TextStyle(),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Card Details Section
                Text(
                  'payment.card_details'.tr,
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gabarito',
                        ) ??
                        const TextStyle(),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Number Field
                _buildCardNumberField(),
                const SizedBox(height: 12),

                // CVV and Expiry Date in a row
                Row(
                  children: [
                    Expanded(child: _buildExpiryField()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildCvvField()),
                  ],
                ),
                const SizedBox(height: 12),

                // Cardholder Name field
                _buildCardholderNameField(),
                const SizedBox(height: 12),

                // Email field (optional)
                _buildEmailField(),
                const SizedBox(height: 24),

                // Options
                _buildSaveCardOption(),
                const SizedBox(height: 8),
                _buildSetDefaultOption(),

                // Spacer to push button to bottom
                const Spacer(),

                // Save Button
                Obx(() => _buildSaveButton()),
                const SizedBox(height: 24),

                // Bottom navigation indicator
                Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'payment.card_number'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardNumberController,
          focusNode: _cardNumberFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(19),
            _CardNumberInputFormatter(),
          ],
          decoration: _buildInputDecoration('1234 5678 9012 3456'),
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
          onChanged: (value) {
            setState(() {}); // Rebuild for card brand detection
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
        Text(
          'payment.expiry_date'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _expiryController,
          focusNode: _expiryFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            _ExpiryDateInputFormatter(),
          ],
          decoration: _buildInputDecoration('MM/YY'),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.expiry_date_required'.translate();
            }
            if (!_paymentController.validateExpiryDate(value!)) {
              return 'payment.form_validation.invalid_expiry_format'
                  .translate();
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
        Text(
          'payment.cvv'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cvvController,
          focusNode: _cvvFocus,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: _buildInputDecoration('123'),
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
        Text(
          'payment.cardholder_name'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardholderNameController,
          focusNode: _cardholderNameFocus,
          textCapitalization: TextCapitalization.words,
          decoration: _buildInputDecoration('John Doe'),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'payment.form_validation.cardholder_name_required'
                  .translate();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.email'.translate() + ' (${'common.optional'.translate()})',
          style: LocalizationService.getLocalizedTextStyle(
            context,
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ) ??
                const TextStyle(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration('john@example.com'),
        ),
      ],
    );
  }

  Widget _buildSaveCardOption() {
    return Row(
      children: [
        Checkbox(
          value: _saveCard,
          onChanged: (value) {
            setState(() {
              _saveCard = value ?? false;
              if (!_saveCard) _setAsDefault = false;
            });
          },
        ),
        Expanded(
          child: Text(
            'payment.save_card'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontFamily: 'Poppins') ??
                  const TextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetDefaultOption() {
    return Row(
      children: [
        Checkbox(
          value: _setAsDefault,
          onChanged:
              _saveCard
                  ? (value) {
                    setState(() {
                      _setAsDefault = value ?? false;
                    });
                  }
                  : null,
        ),
        Expanded(
          child: Text(
            'payment.set_as_default'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Poppins',
                    color:
                        _saveCard
                            ? null
                            : Theme.of(context).colorScheme.outline,
                  ) ??
                  const TextStyle(),
            ),
          ),
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
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child:
            _paymentController.isLoading.value
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(
                  'common.save'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.onPrimary,
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      hintText: hint,
      hintStyle: LocalizationService.getLocalizedTextStyle(
        context,
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontFamily: 'Poppins',
            ) ??
            const TextStyle(),
      ),
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
    final email =
        _emailController.text.isNotEmpty ? _emailController.text : null;

    final success = await _paymentController.createAndSavePaymentMethod(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvc: cvv,
      cardholderName: cardholderName,
      email: email,
      setAsDefault: _setAsDefault,
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
