// lib/features/subcategory/views/screens/subcategory_products_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/filter/screen/view/filter_screen.dart';
import 'package:store_go/features/home/controllers/home_controller.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/profile/controllers/profile_controller.dart';
import 'package:store_go/features/search/no_search_result.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';
import 'package:store_go/features/subcategory/models/subcategory_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class SubcategoryProductsScreen extends StatefulWidget {
  final Subcategory subcategory;

  SubcategoryProductsScreen({super.key})
      : subcategory = Get.arguments as Subcategory;

  @override
  State<SubcategoryProductsScreen> createState() => _SubcategoryProductsScreenState();
}

class _SubcategoryProductsScreenState extends State<SubcategoryProductsScreen> {
  final HomeController homeController = Get.find<HomeController>();
  late SubcategoryController subcategoryController;
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    subcategoryController = Get.find<SubcategoryController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      subcategoryController.fetchSubcategoryProducts(widget.subcategory.id);
    });
  }

  void applyFilters() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return FilterPage();
        },
      ),
    );

    if (result != null) {
      final String subcategoryId = result['subcategoryId'];
      final double minPrice = result['minPrice'];
      final double maxPrice = result['maxPrice'];

      // Update the current subcategory if changed
      if (subcategoryId.isNotEmpty && subcategoryId != widget.subcategory.id) {
        final newSubcategory = subcategoryController.subcategories
            .firstWhereOrNull((sub) => sub.id == subcategoryId);
        if (newSubcategory != null) {
          subcategoryController.selectSubcategory(newSubcategory);
        }
      }

      // Apply price filter locally
      subcategoryController.subcategoryProducts.assignAll(
        subcategoryController.subcategoryProducts.where((product) {
          return product.price >= minPrice && product.price <= maxPrice;
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomSearchBar(
                      onSearch: (query) =>
                          subcategoryController.searchSubcategoryProducts(query),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: applyFilters,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AssetConfig.filter,
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Obx(
                () => Text(
                  '${subcategoryController.subcategoryProducts.length} Results Found in ${widget.subcategory.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (subcategoryController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                if (subcategoryController.hasError.value) {
                  return Center(
                    child: Text(
                      'Error: ${subcategoryController.errorMessage.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (subcategoryController.subcategoryProducts.isEmpty) {
                  return NoSearchResult(
                    onExploreCategories: () {
                      if (subcategoryController.isSearchActive.value) {
                        subcategoryController.clearSearch();
                      } else {
                        subcategoryController.fetchSubcategoryProducts(widget.subcategory.id);
                      }
                    },
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 159 / 280,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: subcategoryController.subcategoryProducts.length,
                    itemBuilder: (context, index) {
                      final product = subcategoryController.subcategoryProducts[index];
                      return ProductCard(
                        product: product,
                        onProductTap: (id) => homeController.onProductTap(id),
                        onFavoriteTap: (id) {
                          // Implement favorite toggle if needed
                        },
                        width: 159,
                        height: 280,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}