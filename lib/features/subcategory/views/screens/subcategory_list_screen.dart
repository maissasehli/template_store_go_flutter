import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/api_client.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/repositories/subcategory_repository.dart';

class SubcategoryListScreen extends StatefulWidget {
  final Category category;

  SubcategoryListScreen({super.key}) : category = Get.arguments as Category;

  @override
  State<SubcategoryListScreen> createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  late SubcategoryController subcategoryController;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<SubcategoryController>()) {
      subcategoryController = Get.find<SubcategoryController>();
    } else {
      subcategoryController = Get.put(
        SubcategoryController(
          repository: SubcategoryRepository(apiClient: Get.find<ApiClient>()),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subcategoryController.setCategory(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
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
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) {
                        // Search within subcategories (optional)
                        // For now, we won't implement search here
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Subcategories in ${widget.category.name}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground(context),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() {
                  if (subcategoryController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary(context),
                      ),
                    );
                  } else if (subcategoryController.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            subcategoryController.errorMessage.value,
                            style: TextStyle(
                              color: AppColors.destructive(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(context),
                              foregroundColor: AppColors.primaryForeground(context),
                            ),
                            onPressed: () => subcategoryController.fetchSubcategories(widget.category.id),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (subcategoryController.subcategories.isEmpty) {
                    return const NoSearchResult(
                      onExploreCategories: null, // No action needed here
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: subcategoryController.subcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = subcategoryController.subcategories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          tileColor: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            subcategory.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () => subcategoryController.selectSubcategory(subcategory),
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