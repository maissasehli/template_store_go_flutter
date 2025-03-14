import 'package:flutter/material.dart';
import 'package:store_go/core/model/home/category_model.dart';

class CategoryFilter extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  }) : super(key: key);

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
                onTap: () => onCategorySelected(category.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: _buildCategoryIcon(category.icon, isSelected, context),
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
                        color: isSelected ? Theme.of(context).primaryColor : Colors.black,
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

  Widget _buildCategoryIcon(String? iconPath, bool isSelected, BuildContext context) {
    if (iconPath == null || iconPath.isEmpty) {
      return Icon(
        Icons.category,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        size: 28,
      );
    }

    final String path = iconPath.startsWith('asset://') ? iconPath.replaceFirst('asset://', '') : iconPath;

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
}
