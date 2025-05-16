import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_typography_extension.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/views/widgets/category_tile.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/search/no_search_result.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find<CategoryController>();
    final textStyles = Theme.of(context).extension<AppTypographyExtension>()!;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: GestureDetector(
        // Dismiss keyboard when tapping anywhere on the screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: UIConfig.paddingMedium,
                  left: UIConfig.paddingMedium,
                  right: UIConfig.paddingMedium,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary(context),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: ThemeAwareSvg(
                          assetPath: AssetConfig.backArrow,
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    SizedBox(width: UIConfig.marginSmall),
                    Expanded(
                      child: CustomSearchBar(
                        onSearch: (query) {
                          if (query.isEmpty) {
                            controller.clearSearch();
                          } else {
                            controller.filterCategories(query);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: UIConfig.marginLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIConfig.paddingLarge,
                ),
                child: Text('Shop by Categories', style: textStyles.h5),
              ),
              SizedBox(height: UIConfig.marginLarge),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIConfig.paddingLarge,
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary(context),
                        ),
                      );
                    } else if (controller.hasError.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.errorMessage.value,
                              style: textStyles.bodyMedium.copyWith(
                                color: AppColors.destructive(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: UIConfig.marginMedium),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary(context),
                                foregroundColor: AppColors.primaryForeground(
                                  context,
                                ),
                              ),
                              onPressed: controller.fetchCategories,
                              child: Text(
                                'Retry',
                                style: textStyles.buttonText.copyWith(
                                  color: AppColors.primaryForeground(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (controller.filteredCategories.isEmpty) {
                      return NoSearchResult(
                        onExploreCategories: () {
                          if (controller.isSearchActive.value) {
                            controller.clearSearch();
                          } else {
                            controller.fetchCategories();
                          }
                        },
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.filteredCategories[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: UIConfig.marginSmall,
                          ),
                          child: CategoryTile(
                            category: category,
                            onTap: () => controller.selectCategory(category),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
