import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/category/models/categories_model.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';

class ListCategoryProduct extends GetView<ProductControllerImp> {
   final productController = Get.put(ProductControllerImp());

   ListCategoryProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        
        if (controller.categories.isEmpty) {
          // If categories list is empty, try fetching them again
          controller.fetchCategories();
          
          return const Center(
            child: Text('No categories available'),
          );
        }
        
        // Display categories
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Obx(() => Categories(
              categoriesModel: category,
              isSelected: category.id == controller.selectedCat.value,
              onTap: () {
                print("Category tapped: ${category.name} (${category.id})");
                controller.changeCat(category.id);
              },
            ));
          },
        );
      }),
    );
  }
}

class Categories extends StatelessWidget {
  final CategoriesModels categoriesModel;
  final bool isSelected;
  final void Function()? onTap;
  
  const Categories({
    super.key,
    required this.categoriesModel,
    required this.isSelected,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: null, // Hug content width
        height: 30,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.black
              : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category name
            Text(
              categoriesModel.name ?? 'Unknown',
              style: TextStyle(
                color: isSelected
                    ? Colors.white 
                    : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}