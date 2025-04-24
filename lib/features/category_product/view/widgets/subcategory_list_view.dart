import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/view/screen/filter_product_screen.dart';

class SubcategoryListView extends GetView<SubcategoryController> {
  final VoidCallback onApplyFilters;
  final ProductFilterController filterController = Get.find<ProductFilterController>();
  final ProductListController listController = Get.find<ProductListController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  SubcategoryListView({
    super.key,
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
        categoryController: categoryController,
        subcategoryController: controller,
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
                      '${listController.products.length}',
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
              if (controller.subcategories.isEmpty) {
                return const Center(child: Text('No subcategories available'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.subcategories.length, // Removed +1 for "All"
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final subcategory = controller.subcategories[index];
                  return _buildSubcategoryPill(
                    name: subcategory.name,
                    isSelected: subcategory.id == controller.currentSubcategoryId.value,
                    onTap: () {
                      controller.currentSubcategoryId.value = subcategory.id;
                      onApplyFilters();
                    },
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSubcategoryPill({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
          name,
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