
// Header section with Clear, title, and Close button
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class FilterHeader extends StatelessWidget {
  final ProductListController listController;
  final SubcategoryController subcategoryController;
  
  const FilterHeader({
    super.key,
    required this.listController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              listController.clearFilters();
              subcategoryController.resetState();
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: UIConfig.fontSizeRegular,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground(context),
              ),
            ),
          ),
          Text(
            'Filter by',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: UIConfig.fontSize2XLarge - 8, // 24 equivalent
              fontWeight: FontWeight.w700,
              color: AppColors.foreground(context),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: AppColors.foreground(context), size: 24),
          ),
        ],
      ),
    );
  }
}