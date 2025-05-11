import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/category/models/category.model.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>()!;
    
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: colors.foreground.withOpacity(0.05),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.card,
                  ),
                  child: _buildCategoryIcon(category, context, colors),
                ),
                const SizedBox(width: UIConfig.paddingMedium),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category category, BuildContext context, AppColorExtension colors) {
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
              color: colors.mutedForeground,
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
              color: colors.mutedForeground,
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
        color: colors.mutedForeground,
      );
    }
  }
}