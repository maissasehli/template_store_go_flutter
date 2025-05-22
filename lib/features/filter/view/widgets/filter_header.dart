// Header section with Clear, title, and Close button
import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/app/core/localization/localization_service.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';

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
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              listController.clearFilters();
              subcategoryController.resetState();
              Navigator.pop(context);
            },
            child: Text(
              'filter.clear'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: UIConfig.fontSizeRegular,
                  fontWeight: FontWeight.w500,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
          ),
          Text(
            'filter.title'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                fontFamily: 'Poppins',
                fontSize: UIConfig.fontSize2XLarge - 8, // 24 equivalent
                fontWeight: FontWeight.w700,
                color: AppColors.foreground(context),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: AppColors.foreground(context),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
