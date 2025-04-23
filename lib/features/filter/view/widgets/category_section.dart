import 'package:flutter/material.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';
import 'category_button.dart';

class CategorySection extends StatelessWidget {
  final String selectedCategoryId;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final Function(String) onCategorySelected;
  final Function(String) onSubcategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.categories,
    required this.subcategories,
    required this.onCategorySelected,
    required this.onSubcategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégorie',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF121826),
          ),
        ),
        const SizedBox(height: 12),
        
        // Categories row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CategoryButton(
              label: 'All',
              isSelected: selectedCategoryId == 'All',
              onTap: () => onCategorySelected('All'),
            ),
            ...categories.map((category) => CategoryButton(
                  label: category.name,
                  isSelected: selectedCategoryId == category.id,
                  onTap: () => onCategorySelected(category.id),
                )),
          ],
        ),
        
        // Subcategories row (shown only if a category is selected and subcategories exist)
        if (selectedCategoryId != 'All' && subcategories.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Sous-catégories',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF121826),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subcategories.map((subcategory) => CategoryButton(
                  label: subcategory.name,
                  isSelected: selectedCategoryId == subcategory.id,
                  onTap: () => onSubcategorySelected(subcategory.id),
                )).toList(),
          ),
        ],
      ],
    );
  }
}