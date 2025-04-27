// Category filter widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_chip.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class CategoryFilter extends StatelessWidget {
  final ProductFilterController filterController;
  final CategoryController categoryController;
  final SubcategoryController subcategoryController;

  const CategoryFilter({
    super.key,
    required this.filterController,
    required this.categoryController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children: [
            // "All" option always first
            CustomFilterChip(
              label: 'All',
              isSelected: filterController.selectedCategory.value == 'All',
              onTap: () {
                filterController.selectedCategory.value = 'All';
                filterController.selectedSubcategoryId.value = '';
                subcategoryController.resetState();
              },
            ),
            const SizedBox(width: 8),
            // Dynamic categories from the controller
            ...categoryController.categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CustomFilterChip(
                  label: category.name,
                  isSelected:
                      filterController.selectedCategory.value == category.id,
                  onTap: () {
                    filterController.selectedCategory.value = category.id;
                    filterController.selectedSubcategoryId.value = '';
                    subcategoryController.setCategory(category.id);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
