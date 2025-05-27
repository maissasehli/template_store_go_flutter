import 'package:flutter/material.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import '../../models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
    required this.onSetDefault,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.08)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.outline.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Card Brand Icon
                _buildCardBrandIcon(context),
                const SizedBox(width: 12),

                // Card Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              paymentMethod.displayName,
                              style: LocalizationService.getLocalizedTextStyle(
                                context,
                                Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                    ) ??
                                    const TextStyle(),
                              ),
                            ),
                          ),
                          // Default Badge (inline with name)
                          if (paymentMethod.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'payment.default_label'.translate(),
                                style:
                                    LocalizationService.getLocalizedTextStyle(
                                      context,
                                      Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            fontFamily: 'Poppins',
                                          ) ??
                                          const TextStyle(),
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildCardSubtitle(),
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ) ??
                              const TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator & Menu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // More Options
                    PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.outline,
                          size: 18,
                        ),
                      ),
                      onSelected: _handleMenuSelection,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder:
                          (context) => [
                            if (!paymentMethod.isDefault)
                              PopupMenuItem(
                                value: 'set_default',
                                child: Row(
                                  children: [
                                    const Icon(Icons.star_outline),
                                    const SizedBox(width: 8),
                                    Text(
                                      'payment.set_as_default'.translate(),
                                      style:
                                          LocalizationService.getLocalizedTextStyle(
                                            context,
                                            Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium ??
                                                const TextStyle(),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'payment.delete_method'.translate(),
                                    style:
                                        LocalizationService.getLocalizedTextStyle(
                                          context,
                                          TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBrandIcon(BuildContext context) {
    final brand = paymentMethod.brand?.toLowerCase() ?? 'unknown';
    IconData iconData;
    Color? iconColor;
    Color? backgroundColor;

    switch (brand) {
      case 'visa':
        iconData = Icons.credit_card;
        iconColor = Colors.blue[700];
        backgroundColor = Colors.blue[50];
        break;
      case 'mastercard':
        iconData = Icons.credit_card;
        iconColor = Colors.red[700];
        backgroundColor = Colors.red[50];
        break;
      case 'amex':
      case 'american express':
        iconData = Icons.credit_card;
        iconColor = Colors.green[700];
        backgroundColor = Colors.green[50];
        break;
      case 'discover':
        iconData = Icons.credit_card;
        iconColor = Colors.orange[700];
        backgroundColor = Colors.orange[50];
        break;
      default:
        iconData = Icons.credit_card;
        iconColor = Theme.of(context).colorScheme.primary;
        backgroundColor = Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.1);
    }

    return Container(
      width: 52,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: iconColor?.withOpacity(0.2) ?? Colors.transparent,
          width: 1,
        ),
      ),
      child: Icon(iconData, color: iconColor, size: 22),
    );
  }

  String _buildCardSubtitle() {
    List<String> parts = [];

    if (paymentMethod.brand != null) {
      parts.add(paymentMethod.brand!.toUpperCase());
    }

    if (paymentMethod.formattedExpiry.isNotEmpty) {
      parts.add(paymentMethod.formattedExpiry);
    }

    if (parts.isEmpty) {
      return _getPaymentMethodDisplay(paymentMethod.type);
    }

    return parts.join(' • ');
  }

  String _getPaymentMethodDisplay(String paymentMethodType) {
    switch (paymentMethodType.toLowerCase()) {
      case 'credit_card':
      case 'card':
        return 'payment.method.credit_card'.translate();
      case 'debit_card':
        return 'payment.method.debit_card'.translate();
      case 'paypal':
        return 'payment.method.paypal'.translate();
      case 'apple_pay':
        return 'payment.method.apple_pay'.translate();
      case 'google_pay':
        return 'payment.method.google_pay'.translate();
      default:
        return paymentMethodType.replaceAll('_', ' ').toUpperCase();
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'set_default':
        onSetDefault();
        break;
      case 'delete':
        onDelete();
        break;
    }
  }
}
