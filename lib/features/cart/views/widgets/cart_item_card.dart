import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Dismissible(
      key: Key(item.id),
      direction:
          isRtl ? DismissDirection.startToEnd : DismissDirection.endToStart,
      onDismissed: (direction) => onRemove(),
      background: _buildDismissBackground(context, isRtl, true),
      secondaryBackground: _buildDismissBackground(context, isRtl, false),
      child: Container(
        margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.03),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
            child: IntrinsicHeight(
              child: Row(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProductImage(context, isRtl),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(UIConfig.paddingSmall),
                      color: Colors.transparent,
                      child: _buildProductDetails(context, isRtl),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(
    BuildContext context,
    bool isRtl,
    bool isPrimary,
  ) {
    final bool shouldShowDelete =
        (isRtl && isPrimary) || (!isRtl && !isPrimary);

    return Container(
      margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
      decoration: BoxDecoration(
        color:
            shouldShowDelete
                ? AppColors.destructive(context)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
      ),
      alignment:
          shouldShowDelete
              ? (isRtl ? Alignment.centerLeft : Alignment.centerRight)
              : Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child:
          shouldShowDelete
              ? SvgPicture.asset(
                AssetConfig.delete,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.destructiveForeground(context),
                  BlendMode.srcIn,
                ),
              )
              : null,
    );
  }

  Widget _buildProductImage(BuildContext context, bool isRtl) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft:
            isRtl ? Radius.zero : Radius.circular(UIConfig.borderRadiusLarge),
        bottomLeft:
            isRtl ? Radius.zero : Radius.circular(UIConfig.borderRadiusLarge),
        topRight:
            isRtl ? Radius.circular(UIConfig.borderRadiusLarge) : Radius.zero,
        bottomRight:
            isRtl ? Radius.circular(UIConfig.borderRadiusLarge) : Radius.zero,
      ),
      child: SizedBox(
        width: 100,
        child:
            item.image.isNotEmpty
                ? Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.secondary(context),
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          strokeWidth: 2,
                          color: AppColors.primary(context),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.secondary(context),
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.muted(context),
                        size: 32,
                      ),
                    );
                  },
                )
                : Container(
                  color: AppColors.secondary(context),
                  child: Icon(
                    Icons.image,
                    color: AppColors.muted(context),
                    size: 32,
                  ),
                ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, bool isRtl) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side content (product info)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: UIConfig.paddingSmall,
                bottom: UIConfig.paddingSmall,
                left: isRtl ? 0 : UIConfig.paddingSmall,
                right: isRtl ? UIConfig.paddingSmall : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    item.name,
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(
                        fontSize: UIConfig.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.foreground(context),
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Category (if available)
                  if (item.category != null && item.category!.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      item.category!,
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(
                          fontSize: UIConfig.fontSizeSmall,
                          color: AppColors.mutedForeground(context),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: UIConfig.paddingSmall),

                  // Variants row (color and size indicators)
                  if (_hasVariants())
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.selectedColor != null &&
                            item.selectedColor!.isNotEmpty) ...[
                          _buildColorIndicator(context),
                          SizedBox(width: UIConfig.paddingSmall),
                        ],
                        if (item.selectedSize != null &&
                            item.selectedSize!.isNotEmpty) ...[
                          _buildSizeIndicator(context),
                        ],
                      ],
                    ),

                  SizedBox(height: UIConfig.paddingSmall),

                  // Bottom row with quantity controls and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price on the left in LTR, right in RTL
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: LocalizationService.getLocalizedTextStyle(
                          context,
                          TextStyle(
                            fontSize: UIConfig.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.foreground(context),
                          ),
                        ),
                      ),

                      // Quantity controls on the right in LTR, left in RTL
                      _buildQuantityControls(context, isRtl),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorIndicator(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _getColorFromString(item.selectedColor!),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
    );
  }

  Widget _buildSizeIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border(context), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.selectedSize!,
        style: LocalizationService.getLocalizedTextStyle(
          context,
          TextStyle(
            fontSize: UIConfig.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppColors.foreground(context),
          ),
        ),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    // Handle hex colors
    if (colorName.startsWith('#')) {
      try {
        return Color(int.parse(colorName.replaceFirst('#', '0xFF')));
      } catch (e) {
        return Colors.grey;
      }
    }

    // Handle color names
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  bool _hasVariants() {
    return (item.selectedColor != null && item.selectedColor!.isNotEmpty) ||
        (item.selectedSize != null && item.selectedSize!.isNotEmpty);
  }

  Widget _buildQuantityControls(BuildContext context, bool isRtl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr, // Always LTR for quantity controls
        children: [
          // Minus button
          _buildQuantityButton(
            context,
            icon: Icons.remove,
            onTap: () {
              if (item.quantity > 1) {
                onQuantityChanged(item.quantity - 1);
              } else {
                onRemove();
              }
            },
          ),

          // Quantity display
          Container(
            constraints: const BoxConstraints(minWidth: 24),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Plus button
          _buildQuantityButton(
            context,
            icon: Icons.add,
            onTap: () => onQuantityChanged(item.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(), // Removed background decoration
        child: Icon(icon, size: 16, color: AppColors.foreground(context)),
      ),
    );
  }
}
