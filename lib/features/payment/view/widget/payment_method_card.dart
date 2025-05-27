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
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
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
                      Text(
                        paymentMethod.displayName,
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ) ??
                              const TextStyle(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildCardSubtitle(),
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontFamily: 'Poppins',
                              ) ??
                              const TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),

                // More Options
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  onSelected: _handleMenuSelection,
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
                                            Theme.of(context).colorScheme.error,
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

            // Default Badge
            if (paymentMethod.isDefault) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'payment.default_method'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ) ??
                        const TextStyle(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardBrandIcon(BuildContext context) {
    final brand = paymentMethod.brand?.toLowerCase() ?? 'unknown';
    IconData iconData;
    Color? iconColor;

    switch (brand) {
      case 'visa':
        iconData = Icons.credit_card;
        iconColor = Colors.blue[700];
        break;
      case 'mastercard':
        iconData = Icons.credit_card;
        iconColor = Colors.red[700];
        break;
      case 'amex':
      case 'american express':
        iconData = Icons.credit_card;
        iconColor = Colors.green[700];
        break;
      case 'discover':
        iconData = Icons.credit_card;
        iconColor = Colors.orange[700];
        break;
      default:
        iconData = Icons.credit_card;
        iconColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: iconColor?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
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
      return paymentMethod.type.replaceAll('_', ' ').toUpperCase();
    }

    return parts.join(' • ');
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
