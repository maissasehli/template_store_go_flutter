import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/category_product/view/screen/category_products_screen.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/view/screen/filter_product_screen.dart';

class CategoryListView extends GetView<CategoryController> {
  final CategoryProductController categoryProductController;
  final ProductFilterController filterController = Get.find<ProductFilterController>();
  final ProductListController listController = Get.find<ProductListController>();
  final SubcategoryController subcategoryController = Get.find<SubcategoryController>();
  final VoidCallback onApplyFilters;

  CategoryListView({
    super.key,
    required this.categoryProductController,
    required this.onApplyFilters,
  });

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        listController: listController,
        filterController: filterController,
        categoryController: controller,
        subcategoryController: subcategoryController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 8),
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetConfig.filter,
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                      '${categoryProductController.categoryProducts.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
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
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Obx(() {
                    final isSelected = category.id == controller.selectedCategoryId.value;
                    return CategoryPill(
                      category: category,
                      isSelected: isSelected,
                      onTap: () {
                        // First select the category in the controller
                        controller.selectCategory(category);
                        
                        // Reset any active subcategory
                        subcategoryController.currentSubcategoryId.value = '';
                        subcategoryController.setCategory(category.id);
                        
                        // Set the category in product controller and fetch products
                        categoryProductController.setCategory(category);
                        categoryProductController.fetchCategoryProducts(category.id);
                        
                        // Apply filters after changing category
                        onApplyFilters();
                        
                        // If we're on a different screen, navigate to CategoryProductsScreen with the new category
                        if (Get.currentRoute != '/category_products') {
                          Get.to(() => CategoryProductsScreen(), arguments: category);
                        }
                      },
                    );
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CategoryPill extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

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