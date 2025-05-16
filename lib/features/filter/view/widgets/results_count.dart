// Results count widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';

class ResultsCount extends StatelessWidget {
  final ProductListController listController;
  
  const ResultsCount({
    super.key, 
    required this.listController
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingMedium),
      child: Obx(
        () => Text(
          '${listController.products.length} Results Found',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: UIConfig.fontSizeSmall,
            fontWeight: FontWeight.w400,
            color: AppColors.mutedForeground(context),
          ),
        ),
      ),
    );
  }
}