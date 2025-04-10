import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/controllers/category_controller.dart';
import 'package:store_go/features/category/models/categories_model.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find<CategoryController>();

    return Scaffold(
      backgroundColor: Colors.white,
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
                      color: const Color(0xFFF4F4F4), 
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Search bar (expanded to fill remaining space)
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) {
                        // Trigger category search 
                        controller.searchCategories(query);
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
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.0, 
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Categories list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.categories.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CategoryTile(
                          category: category,
                          onTap: () => controller.selectCategory(category.id!),
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

// Updated CategoryTile class from CategoryScreen
class CategoryTile extends StatelessWidget {
  final CategoriesModels category;
  final Function() onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();

    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Only proceed if category id is not null
            if (category.id != null) {
              // Update selected category
              categoryController.selectCategory(category.id!);
              
              // Navigate to ProductScreen with selected category and categories list
             categoryController.gotoProduct(
  categories: categoryController.categories,
  selectedCategoryId: category.id ?? '',
);

            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, 
                  ),
                  child: _buildCategoryIcon(),
                ),
                const SizedBox(width: 16),
                Text(
                  category.name ?? '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.0, 
                    letterSpacing: 0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    // If imageUrl is null or empty, show default icon
    if (category.imageUrl == null || category.imageUrl!.isEmpty) {
      return const Icon(Icons.category, size: 24, color: Colors.grey);
    }

    // Prepare the image path, removing 'assets/' prefix if needed
    final String imagePath = category.imageUrl!.startsWith('assets/') 
        ? category.imageUrl! 
        : 'assets/${category.imageUrl!}';

    return ClipOval(
      child: Image.asset(
        imagePath,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default icon if image fails to load
          return const Icon(Icons.category, size: 24, color: Colors.grey);
        },
      ),
    );
  }

}