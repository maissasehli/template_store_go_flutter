import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/home/models/category_model.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and search bar in the same row
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.muted(context),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.foreground(context),
                        size: 20,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Search bar (expanded to fill remaining space)
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) {
                        // Handle search functionality
                        if (query.isNotEmpty) {
                          // Navigate to search results or filter categories
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Shop by Categories',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: 0,
                  color: AppColors.foreground(context),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Categories list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() {
                  // Show loading indicator while fetching data
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary(context),
                      ),
                    );
                  }
                  // Show error message if there's an error
                  else if (controller.errorMessage.value != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.errorMessage.value!,
                            style: TextStyle(
                              color: AppColors.destructive(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(context),
                              foregroundColor: AppColors.primaryForeground(
                                context,
                              ),
                            ),
                            onPressed: controller.fetchCategories,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Show empty state message if no categories found
                  else if (controller.categories.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories found',
                        style: TextStyle(
                          color: AppColors.mutedForeground(context),
                        ),
                      ),
                    );
                  }
                  // Show the list of categories
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CategoryTile(
                          category: category,
                          onTap: () => controller.selectCategory(category.id),
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
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.muted(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card(context),
                  ),
                  child: _buildCategoryIcon(category, context),
                ),
                const SizedBox(width: 16),
                Text(
                  category.name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.foreground(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category category, BuildContext context) {
    // Check if the icon is a network URL
    if (category.imageUrl != null && category.imageUrl!.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if image fails to load
            return Icon(
              Icons.category,
              size: 24,
              color: AppColors.mutedForeground(context),
            );
          },
        ),
      );
    }
    // Check if it's an asset path
    else if (category.imageUrl != null) {
      return ClipOval(
        child: Image.asset(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if asset fails to load
            return Icon(
              Icons.category,
              size: 24,
              color: AppColors.mutedForeground(context),
            );
          },
        ),
      );
    }
    // Use default icon if no icon is provided
    else {
      return Icon(
        Icons.category,
        size: 24,
        color: AppColors.mutedForeground(context),
      );
    }
  }
}
