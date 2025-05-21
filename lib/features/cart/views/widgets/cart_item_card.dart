import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:get/get.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

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
      // Use directional dismissal based on RTL
      direction:
          isRtl ? DismissDirection.startToEnd : DismissDirection.endToStart,
      // Handle removal when dismissed
      onDismissed: (direction) {
        onRemove();
      },
      // In RTL mode, we swap the backgrounds
      background:
          isRtl
              ? Container(
                margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
                height: 105.87,
                decoration: BoxDecoration(
                  color: AppColors.destructive(context),
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: UIConfig.paddingMedium),
                child: SvgPicture.asset(
                  AssetConfig.delete,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.destructiveForeground(context),
                    BlendMode.srcIn,
                  ),
                ),
              )
              : Container(
                margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
              ),
      secondaryBackground:
          isRtl
              ? Container(
                margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
              )
              : Container(
                margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
                height: 105.87,
                decoration: BoxDecoration(
                  color: AppColors.destructive(context),
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusLarge,
                  ),
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: UIConfig.paddingMedium),
                child: SvgPicture.asset(
                  AssetConfig.delete,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.destructiveForeground(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
      child: Container(
        margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
        height: 105.87,
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.05),
              blurRadius: 25.41,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            _buildProductImage(context, isRtl),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(UIConfig.paddingSmall),
                child: _buildProductDetails(context, isRtl),
              ),
            ),
            _buildQuantityControls(context),
            SizedBox(width: UIConfig.marginSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, bool isRtl) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft:
            isRtl
                ? Radius.circular(0)
                : Radius.circular(UIConfig.borderRadiusLarge),
        bottomLeft:
            isRtl
                ? Radius.circular(0)
                : Radius.circular(UIConfig.borderRadiusLarge),
        topRight:
            isRtl
                ? Radius.circular(UIConfig.borderRadiusLarge)
                : Radius.circular(0),
        bottomRight:
            isRtl
                ? Radius.circular(UIConfig.borderRadiusLarge)
                : Radius.circular(0),
      ),
      child:
          item.image.isNotEmpty
              ? Image.network(
                item.image,
                width: 80,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: double.infinity,
                    color: AppColors.secondary(context),
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.muted(context),
                    ),
                  );
                },
              )
              : Container(
                width: 80,
                height: double.infinity,
                color: AppColors.secondary(context),
                child: Icon(Icons.image, color: AppColors.muted(context)),
              ),
    );
  }

  Widget _buildProductDetails(BuildContext context, bool isRtl) {
    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
        ),
        if (item.variantId.isNotEmpty)
          Text(
            item.variantId,
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
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
          ),
        SizedBox(height: UIConfig.marginSmall),
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
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Container(
      width: 74.11,
      height: 31.76,
      decoration: BoxDecoration(
        color: AppColors.secondary(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
          SizedBox(
            width: 24,
            child: Center(
              child: Text(
                '${item.quantity}',
                style: TextStyle(
                  fontSize: UIConfig.fontSizeRegular,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
          ),
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
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: Icon(icon, size: 16, color: AppColors.foreground(context)),
        ),
      ),
    );
  }
}
