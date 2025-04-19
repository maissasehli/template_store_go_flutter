// widgets/category_section.dart
import 'package:flutter/material.dart';
import 'category_button.dart';

class CategorySection extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
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
        
        // Categories first row
        Row(
          children: [
            CategoryButton(
              label: 'All',
              isSelected: selectedCategory == 'All',
              onTap: () => onCategorySelected('All'),
            ),
            const SizedBox(width: 8),
            CategoryButton(
              label: 'Vêtements',
              isSelected: selectedCategory == 'Vêtements',
              onTap: () => onCategorySelected('Vêtements'),
            ),
            const SizedBox(width: 8),
            CategoryButton(
              label: 'Soins',
              isSelected: selectedCategory == 'Soins',
              onTap: () => onCategorySelected('Soins'),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Categories second row
        Row(
          children: [
            CategoryButton(
              label: 'Tops',
              isSelected: selectedCategory == 'Tops',
              onTap: () => onCategorySelected('Tops'),
            ),
            const SizedBox(width: 8),
            CategoryButton(
              label: 'Shorts',
              isSelected: selectedCategory == 'Shorts',
              onTap: () => onCategorySelected('Shorts'),
            ),
            const SizedBox(width: 8),
            CategoryButton(
              label: 'Cats',
              isSelected: selectedCategory == 'Cats',
              onTap: () => onCategorySelected('Cats'),
            ),
          ],
        ),
      ],
    );
  }
}