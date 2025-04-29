// Subcategory filter widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_chip.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class SubcategoryFilter extends StatelessWidget {
  final ProductFilterController filterController;
  final SubcategoryController subcategoryController;

  const SubcategoryFilter({
    super.key,
    required this.filterController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children:
              subcategoryController.subcategories.map((subcategory) {
                final isSelected =
                    filterController.selectedSubcategoryId.value ==
                    subcategory.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomFilterChip(
                    label: subcategory.name,
                    isSelected: isSelected,
                    onTap: () {
                      if (isSelected) {
                        filterController.selectedSubcategoryId.value = '';
                      } else {
                        filterController.selectedSubcategoryId.value =
                            subcategory.id;
                        subcategoryController.selectSubcategory(subcategory);
                      }
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
