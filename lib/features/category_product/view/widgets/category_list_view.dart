import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/category_product/controller/category_product_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/category_product/view/screen/category_products_screen.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/view/screen/filter_product_sheet.dart';

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
            margin: EdgeInsets.only(
              left: UIConfig.paddingMedium, 
              top: UIConfig.paddingSmall
            ),
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingSmall + 4),
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetConfig.filter,
                  width: 20,
                  height: 20,
                  color: AppColors.primaryForeground(context),
                ),
                SizedBox(width: UIConfig.paddingSmall),
                Obx(() => Text(
                      '${categoryProductController.categoryProducts.length}',
                      style: TextStyle(
                        color: AppColors.primaryForeground(context),
                        fontSize: UIConfig.fontSizeRegular,
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
            margin: EdgeInsets.only(top: UIConfig.paddingSmall),
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary(context),
                    ),
                  ),
                );
              }
              if (controller.categories.isEmpty) {
                controller.fetchCategories();
                return Center(
                  child: Text(
                    'No categories available',
                    style: TextStyle(
                      color: AppColors.mutedForeground(context),
                    ),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
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
        margin: EdgeInsets.only(right: UIConfig.paddingSmall),
        padding: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium, 
          vertical: UIConfig.paddingSmall
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primary(context) 
            : AppColors.input(context),
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected 
              ? AppColors.primaryForeground(context) 
              : AppColors.foreground(context),
            fontWeight: FontWeight.w500,
            fontSize: UIConfig.fontSizeRegular,
          ),
        ),
      ),
    );
  }
}