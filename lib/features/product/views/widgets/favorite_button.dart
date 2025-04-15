import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white, // Using white as seen in the image
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onToggleFavorite,
        borderRadius: BorderRadius.circular(15.6), // Half of width/height for circle
        child: Center(
          child: SvgPicture.asset(
            AssetConfig.heartIcon, // Make sure this constant is defined in your AssetConfig
            width: 18,
            height: 17,
            color: isFavorite 
                ? AppColors.destructive(context) 
                : const Color(0xFF130F26),
          ),
        ),
      ),
    );
  }
}