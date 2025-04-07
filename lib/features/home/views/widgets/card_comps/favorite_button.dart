import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        AssetConfig.heartIcon,
        colorFilter: ColorFilter.mode(
          isFavorite
              ? AppColors.destructive(context)
              : AppColors.mutedForeground(context),
          BlendMode.srcIn,
        ),
        height: 24,
        width: 24,
      ),
    );
  }
}
