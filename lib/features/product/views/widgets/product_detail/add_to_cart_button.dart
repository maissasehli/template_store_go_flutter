import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onRemovePressed;
  final double price;
  final String? buttonText;
  final Product? product;
  final String? variantId;
  final int? quantity;

  const AddToCartButton({
    super.key,
    this.onAddPressed,
    this.onRemovePressed,
    required this.price,
    this.buttonText,
    this.product,
    this.variantId,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isRtl = LocalizationService.isRtl(context);
    final cartController = Get.find<CartController>();

    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: LocalizationService.getLocalizedTextStyle(
            context,
            textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground(context),
                ) ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground(context),
                ),
          ),
        ),
        const SizedBox(width: UIConfig.paddingMedium),
        Expanded(
          child:
              product != null
                  ? // If we have product details, show toggle button with cart status
                  Obx(() {
                    final isInCart = cartController.isProductInCart(
                      product!.id,
                    );

                    return ElevatedButton(
                      onPressed:
                          isInCart
                              ? () {
                                // If product is in cart, remove it
                                cartController.removeFromCart(product!.id);
                                if (onRemovePressed != null) onRemovePressed!();
                              }
                              : () {
                                // If product is not in cart, add it
                                cartController.addToCart(
                                  product!,
                                  quantity: quantity ?? 1,
                                  variants:
                                      variantId != null && variantId!.isNotEmpty
                                          ? {'variantId': variantId}
                                          : null,
                                );
                                if (onAddPressed != null) onAddPressed!();
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isInCart
                                ? AppColors.destructive(context)
                                : AppColors.primary(context),
                        foregroundColor:
                            isInCart
                                ? AppColors.destructiveForeground(context)
                                : AppColors.primaryForeground(context),
                        padding: const EdgeInsets.symmetric(
                          vertical: UIConfig.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            UIConfig.borderRadiusCircular,
                          ),
                        ),
                      ),
                      child: Row(
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isInCart
                                ? Icons.remove_shopping_cart
                                : Icons.shopping_bag_outlined,
                            size: 16,
                            color:
                                isInCart
                                    ? AppColors.destructiveForeground(context)
                                    : AppColors.primaryForeground(context),
                          ),
                          const SizedBox(width: UIConfig.paddingSmall),
                          Text(
                            isInCart
                                ? 'product_detail.remove_from_cart'.translate()
                                : (buttonText ??
                                    'product_detail.add_to_cart'.translate()),
                            style: LocalizationService.getLocalizedTextStyle(
                              context,
                              textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isInCart
                                            ? AppColors.destructiveForeground(
                                              context,
                                            )
                                            : AppColors.primaryForeground(
                                              context,
                                            ),
                                  ) ??
                                  TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isInCart
                                            ? AppColors.destructiveForeground(
                                              context,
                                            )
                                            : AppColors.primaryForeground(
                                              context,
                                            ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                  : // Simple button without cart status checking if no product provided
                  ElevatedButton(
                    onPressed: onAddPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      foregroundColor: AppColors.primaryForeground(context),
                      padding: const EdgeInsets.symmetric(
                        vertical: UIConfig.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusCircular,
                        ),
                      ),
                    ),
                    child: Row(
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: AppColors.primaryForeground(context),
                        ),
                        const SizedBox(width: UIConfig.paddingSmall),
                        Text(
                          buttonText ??
                              'product_detail.add_to_cart'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryForeground(context),
                                ) ??
                                TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryForeground(context),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}
