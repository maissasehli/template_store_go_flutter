import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';

class TopNavigationBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback? onCartPressed;

  const TopNavigationBar({
    super.key,
    required this.onBackPressed,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRtl = LocalizationService.isRtl(context);
    final cartController = Get.find<CartController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: ThemeAwareSvg(
                assetPath:
                    isRtl ? AssetConfig.arrowRight : AssetConfig.arrowLeft,
                height: 24,
                width: 24,
              ),
              padding: EdgeInsets.zero,
              onPressed: onBackPressed,
            ),
          ),

          // Cart button with badge
          Stack(
            children: [
              GestureDetector(
                onTap: onCartPressed ?? () => Get.toNamed('/cart'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.card(context),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetConfig.panierIcon,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.foreground(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              // Cart badge counter
              Obx(() {
                final itemCount = cartController.cartItems.length;
                return itemCount > 0
                    ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary(context),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: AppColors.primaryForeground(context),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
