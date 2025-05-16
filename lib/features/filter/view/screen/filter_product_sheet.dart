import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/filter/view/widgets/filter_content.dart';
import 'package:store_go/features/filter/view/widgets/filter_footer.dart';
import 'package:store_go/features/filter/view/widgets/filter_header.dart';
import 'package:store_go/features/filter/view/widgets/results_count.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

// Main Filter Bottom Sheet Widget
class FilterBottomSheet extends StatelessWidget {
  final ProductListController listController;
  final ProductFilterController filterController;
  final CategoryController categoryController;
  final SubcategoryController subcategoryController;
  
  const FilterBottomSheet({
    super.key,
    required this.listController,
    required this.filterController,
    required this.categoryController,
    required this.subcategoryController,
  });
  
  @override
  Widget build(BuildContext context) {
    // Get theme extensions for colors
    final colors = Theme.of(context).extension<AppColorExtension>()!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConfig.borderRadiusLarge),
          topRight: Radius.circular(UIConfig.borderRadiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          FilterHeader(
            listController: listController,
            subcategoryController: subcategoryController,
          ),
          
          // Results count
          ResultsCount(listController: listController),
          
          const SizedBox(height: UIConfig.paddingMedium),
          
          // Main content (scrollable)
          Expanded(
            child: FilterContent(
              filterController: filterController,
              categoryController: categoryController,
              subcategoryController: subcategoryController,
            ),
          ),
          
          // Apply button and bottom indicator
          FilterFooter(listController: listController),
        ],
      ),
    );
  }
}