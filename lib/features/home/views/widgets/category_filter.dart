import 'package:flutter/material.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/app/core/theme/app_typography_extension.dart';

class CategoryFilter extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme extensions for colors and typography
    final colors = Theme.of(context).extension<AppColorExtension>()!;
    final typography = Theme.of(context).extension<AppTypographyExtension>()!;
    
    return SizedBox(
      height: 120,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category.id == selectedCategoryId;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingSmall + 2),
              child: GestureDetector(
                onTap: () => onCategorySelected(category.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withOpacity(0.1)
                            : colors.muted.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: _buildCategoryIcon(
                        category.imageUrl,
                        isSelected,
                        context,
                        colors,
                      ),
                    ),
                    const SizedBox(height: UIConfig.paddingSmall),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: typography.subtitle2.copyWith(
                        height: 1.6,
                        color: isSelected ? colors.primary : colors.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(
    String? iconPath,
    bool isSelected,
    BuildContext context,
    AppColorExtension colors,
  ) {
    if (iconPath == null || iconPath.isEmpty || iconPath == "none") {
      return Icon(
        Icons.category,
        color: isSelected ? colors.primary : colors.muted,
        size: 45,
      );
    }

    if (iconPath.startsWith('asset://')) {
      final String path = iconPath.replaceFirst('asset://', '');
      return Center(
        child: Image.asset(
          path,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.category,
              color: isSelected ? colors.primary : colors.muted,
              size: 45,
            );
          },
        ),
      );
    } else if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
          child: Image.network(
            iconPath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.category,
                color: isSelected ? colors.primary : colors.muted,
                size: 45,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                color: colors.primary,
                strokeWidth: 2.0,
              );
            },
          ),
        ),
      );
    } else {
      return Icon(
        Icons.category,
        color: isSelected ? colors.primary : colors.muted,
        size: 45,
      );
    }
  }
}