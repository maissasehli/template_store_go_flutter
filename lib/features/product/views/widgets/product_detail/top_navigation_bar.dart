import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
                assetPath: AssetConfig.backArrow,
                height: 24,
                width: 24,
              ),
              padding: EdgeInsets.zero,
              onPressed: onBackPressed,
            ),
          ),

          // Cart button
          Container(
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
        ],
      ),
    );
  }
}
