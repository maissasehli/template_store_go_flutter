import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/controller/categories/category_controller.dart';
import 'package:store_go/core/model/home/category_model.dart';
import 'package:store_go/view/widgets/home/search_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

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
                      color: Color(0xFFF4F4F4), 
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
                    child:CustomSearchBar (
                      onSearch: (query) {
                        // Handle search functionality
                        if (query.isNotEmpty) {
                          // Navigate to search results or filter categories
                          // For example:
                          // Get.to(() => SearchResultsScreen(query: query));
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

  const CategoryTile({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white, 
                  ),
                  child: category.icon != null
                      ? ClipOval(
                          child: Image.asset(
                            category.icon!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.category, size: 24, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Text(
                  category.name ?? 'Category',
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
}

