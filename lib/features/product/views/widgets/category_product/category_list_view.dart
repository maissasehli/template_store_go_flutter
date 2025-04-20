// lib/features/product/views/widgets/category_product/category_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/filter/screen/view/filter_screen.dart';
import 'package:store_go/features/product/controllers/category_product_controller.dart';

class CategoryListView extends GetView<CategoryController> {
  const CategoryListView({super.key, required CategoryProductController categoryProductController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (_, scrollController) {
                  return FilterPage();
                },
              ),
            );
          },
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
                const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      onTap: () => controller.selectCategory(category),
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