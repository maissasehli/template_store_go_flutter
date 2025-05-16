import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

class FilterFooter extends StatelessWidget {
  final ProductListController listController;
  
  const FilterFooter({
    super.key,
    required this.listController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Apply button
        Padding(
          padding: const EdgeInsets.all(UIConfig.paddingMedium),
          child: ElevatedButton(
            onPressed: () {
              listController.applyFilters();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConfig.borderRadiusXLarge),
              ),
            ),
            child: Text(
              'Apply Now',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: UIConfig.fontSizeMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Bottom indicator
        const SizedBox(height: 4),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
