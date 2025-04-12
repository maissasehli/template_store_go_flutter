import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/product/controllers/category_product_controller.dart';

class CategoryListView extends GetView<CategoryController> {
  final CategoryProductController categoryProductController;

  const CategoryListView({Key? key, required this.categoryProductController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(top: 8),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (controller.categories.isEmpty) {
          controller.fetchCategories();
          return const Center(child: Text('No categories available'));
        }

        // Display categories as pills
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            
            // We need to use Obx in the widget tree, not as a variable
            return Obx(() {
              final isSelected = category.id == controller.selectedCategoryId.value;
              
              return CategoryPill(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  // Set the selected category ID
                  controller.selectedCategoryId.value = category.id;

                  // Update the current category in our controller and fetch its products
                  categoryProductController.setCategory(category);
                  // Make sure products are fetched for the new category
                  categoryProductController.fetchCategoryProducts(category.id);

                  // Log when category is changed
                  print("Changed to category: ${category.name} (${category.id})");
                },
              );
            });
          },
        );
      }),
    );
  }
}

class CategoryPill extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}