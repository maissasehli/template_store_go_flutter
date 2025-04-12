// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:store_go/features/category/models/category.modal.dart';

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
    return SizedBox(
      height: 90,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              categories.map((category) {
                final isSelected = category.id == selectedCategoryId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => onCategorySelected(category.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: _buildCategoryIcon(
                            category.imageUrl,
                            isSelected,
                            context,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            color:
                                isSelected
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

  Widget _buildCategoryIcon(
    String? iconPath,
    bool isSelected,
    BuildContext context,
  ) {
    // Return default icon if path is null, empty, or "none"
    if (iconPath == null || iconPath.isEmpty || iconPath == "none") {
      return Icon(
        Icons.category,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        size: 28,
      );
    }

    // Handle asset:// protocol
    if (iconPath.startsWith('asset://')) {
      final String path = iconPath.replaceFirst('asset://', '');
      return Image.asset(
        path,
        width: 28,
        height: 28,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.category,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            size: 28,
          );
        },
      );
    }
    // Handle http:// or https:// URLs
    else if (iconPath.startsWith('http://') ||
        iconPath.startsWith('https://')) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            iconPath,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.category,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                size: 28,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: Theme.of(context).primaryColor,
                strokeWidth: 2.0,
              );
            },
          ),
        ),
      );
    }
    // For other formats, show default icon instead of trying to load as asset
    else {
      return Icon(
        Icons.category,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        size: 28,
      );
    }
  }
}
