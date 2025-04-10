import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/features/category/models/categories_model.dart';

class CategoryListView extends StatelessWidget {
  final List<CategoriesModels> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryListView({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category.id == selectedCategoryId;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  // Only proceed if category id is not null
                  if (category.id != null) {
                    // Call the callback for local state update
                    onCategorySelected(category.id!);
                    
                    // Navigate to product screen with selected category
                    Get.toNamed(
                      AppRoute.productscreen,
                      arguments: {
                        "categories": categories,
                        "selected": category.id
                      }
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withAlpha(25)
                            : Colors.grey.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: _buildCategoryIcon(category.imageUrl, isSelected, context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name ?? 'Unnamed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black,
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

  Widget _buildCategoryIcon(String? imageUri, bool isSelected, BuildContext context) {
    // If no image URI is provided, show default icon
    if (imageUri == null || imageUri.isEmpty) {
      return Icon(
        Icons.category,
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey,
        size: 28,
      );
    }

    // Remove 'assets/' prefix if present
    final String imagePath = imageUri.startsWith('assets/')
        ? imageUri
        : 'assets/$imageUri';

    return Image.asset(
      imagePath,
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default icon if image fails to load
        return Icon(
          Icons.category,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey,
          size: 28,
        );
      },
    );
  }
}