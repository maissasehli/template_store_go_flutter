import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/category/models/category.modal.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.foreground(context).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card(context),
                  ),
                  child: _buildCategoryIcon(category, context),
                ),
                const SizedBox(width: 16),
                Text(
                  category.name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.foreground(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category category, BuildContext context) {
    // Check if the icon is a network URL
    if (category.imageUrl != null && category.imageUrl!.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if image fails to load
            return Icon(
              Icons.category,
              size: 24,
              color: AppColors.mutedForeground(context),
            );
          },
        ),
      );
    }
    // Check if it's an asset path
    else if (category.imageUrl != null) {
      return ClipOval(
        child: Image.asset(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if asset fails to load
            return Icon(
              Icons.category,
              size: 24,
              color: AppColors.mutedForeground(context),
            );
          },
        ),
      );
    }
    // Use default icon if no icon is provided
    else {
      return Icon(
        Icons.category,
        size: 24,
        color: AppColors.mutedForeground(context),
      );
    }
  }
}
