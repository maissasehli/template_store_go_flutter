import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';

class SubcategoryListView extends GetView<SubcategoryController> {
  final VoidCallback applyFilters;

  const SubcategoryListView({super.key, required this.applyFilters});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Filter Button
        GestureDetector(
          onTap: applyFilters,
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
                Obx(() {
                  return Text(
                    '${controller.subcategoryProducts.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        // Subcategory List
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
                controller.fetchSubcategories(controller.currentCategoryId.value);
                return const Center(child: Text('No subcategories available'));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.subcategories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final subcategory = controller.subcategories[index];
                  return Obx(() {
                    final isSelected = subcategory.id == controller.currentSubcategoryId.value;
                    return SubcategoryPill(
                      subcategory: subcategory,
                      isSelected: isSelected,
                      onTap: () => controller.selectSubcategory(subcategory),
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

class SubcategoryPill extends StatelessWidget {
  final Subcategory subcategory;
  final bool isSelected;
  final VoidCallback onTap;

  const SubcategoryPill({
    super.key,
    required this.subcategory,
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
          subcategory.name,
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