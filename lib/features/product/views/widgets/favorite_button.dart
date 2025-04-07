import 'package:flutter/material.dart';
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
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: InkWell(
        onTap: onToggleFavorite,
        child: Center(
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color:
                isFavorite
                    ? AppColors.destructive(context)
                    : AppColors.foreground(context),
          ),
        ),
      ),
    );
  }
}
