// Category filter widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_chip.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

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
    final bool isRtl = LocalizationService.isRtl(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // "All" option always first
            CustomFilterChip(
              label: 'filter.all'.translate(),
              isSelected:
                  filterController.selectedCategory.value ==
                  'filter.all'.translate(),
              onTap: () {
                filterController.selectedCategory.value =
                    'filter.all'.translate();
                filterController.selectedSubcategoryId.value = '';
                subcategoryController.resetState();
              },
            ),
            SizedBox(width: 8),
            // Dynamic categories from the controller
            ...categoryController.categories.map((category) {
              return Padding(
                padding: EdgeInsets.only(
                  right: isRtl ? 0 : 8.0,
                  left: isRtl ? 8.0 : 0,
                ),
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
