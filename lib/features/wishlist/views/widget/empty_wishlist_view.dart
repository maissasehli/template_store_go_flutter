import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class EmptyWishlistView extends StatelessWidget {
  const EmptyWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heart icon with circular background and gray shadow
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: AppColors.background(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.muted(context).withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 26.1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AssetConfig.heartIcon,
                width: 47,
                height: 44.65,
                colorFilter: ColorFilter.mode(
                  AppColors.muted(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: UIConfig.paddingMedium),
          // No wishlist yet text
          Text(
            'No wishlist yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.foreground(context),
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: UIConfig.paddingLarge),
          // Explore Categories button
          ElevatedButton(
            onPressed: () {
              // Get the navigation controller and navigate to categories
              final navController = Get.find<NavigationController>();
              navController.changeTab(0); // Go to home tab first
              Get.toNamed('/categories'); // Then navigate to categories
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              padding: const EdgeInsets.symmetric(
                horizontal: UIConfig.paddingLarge, 
                vertical: UIConfig.paddingMedium
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
              ),
            ),
            child: Text(
              'Explore Categories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryForeground(context),
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}