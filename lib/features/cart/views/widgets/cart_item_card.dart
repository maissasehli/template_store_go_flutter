import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:get/get.dart';
import 'package:store_go/features/cart/models/cart_model.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

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
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final result = await Get.dialog<bool>(
          AlertDialog(
            title: Text(
              'Remove Item',
              style: TextStyle(color: AppColors.foreground(context)),
            ),
            backgroundColor: AppColors.background(context),
            content: Text(
              'Are you sure you want to remove this item from your cart?',
              style: TextStyle(color: AppColors.foreground(context)),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.muted(context)),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'Remove',
                  style: TextStyle(color: AppColors.destructive(context)),
                ),
              ),
            ],
          ),
        );

        if (result == true) {
          onRemove();
        }
        return false;
      },
      background: Container(
        margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: UIConfig.marginMedium),
        height: 105.87, // Match the height of the card
        decoration: BoxDecoration(
          color: AppColors.destructive(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
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
        height: 105.87, // Consider replacing with a UIConfig value
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground(context).withOpacity(0.05),
              blurRadius: 25.41, // Consider replacing with a UIConfig value
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildProductImage(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(UIConfig.paddingSmall),
                child: _buildProductDetails(context),
              ),
            ),
            _buildQuantityControls(context),
            SizedBox(width: UIConfig.marginSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(UIConfig.borderRadiusLarge),
        bottomLeft: Radius.circular(UIConfig.borderRadiusLarge),
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

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontSize: UIConfig.fontSizeMedium,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.variantId.isNotEmpty)
          Text(
            item.variantId,
            style: TextStyle(
              fontSize: UIConfig.fontSizeSmall,
              color: AppColors.mutedForeground(context),
              fontFamily: 'Poppins',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        SizedBox(height: UIConfig.marginSmall),
        Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: UIConfig.fontSizeMedium,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppColors.foreground(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      width: 74.11, // Consider replacing with a UIConfig value
      height: 31.76, // Consider replacing with a UIConfig value
      decoration: BoxDecoration(
        color: AppColors.secondary(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
      ),
      child: Row(
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
