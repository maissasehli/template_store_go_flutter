import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchController = TextEditingController();
  final RxBool showFilterSheet = false.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxList<String> selectedSubcategories = <String>[].obs;
  final RxDouble minPrice = 45.0.obs;
  final RxDouble maxPrice = 220.0.obs;
  final RxString sortBy = 'New Today'.obs;
  final RxInt selectedRating = 0.obs;

  @override
  void initState() {
    super.initState();
    // Set default search query if passed as argument
    final String? initialQuery = Get.arguments as String?;
    if (initialQuery != null && initialQuery.isNotEmpty) {
      searchController.text = initialQuery;
      productController.searchProducts(initialQuery);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    productController.searchProducts(query);
  }

  void _showFilterBottomSheet() {
    showFilterSheet.value = true;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCategoryFilterChips(),
              const SizedBox(height: 16),
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPriceRangeSlider(),
              const SizedBox(height: 16),
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildSortOptions(),
              const SizedBox(height: 16),
              const Text(
                'Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildRatingFilter(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        productController.clearFilters();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        productController.filterProducts(
                          category:
                              selectedCategory.value != 'All'
                                  ? selectedCategory.value
                                  : null,
                          minPrice: minPrice.value,
                          maxPrice: maxPrice.value,
                          sortBy: sortBy.value,
                          rating: selectedRating.value,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // The missing build method - this was the main issue
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterBottomSheet,
                ),
              ],
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildFilterChips(),
          ),

          // Products grid or no results
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (productController.products.isEmpty) {
                return _buildNoResultsFound();
              }

              return _buildProductsGrid();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Clothing'),
          _buildFilterChip('Shoes'),
          _buildFilterChip('Accessories'),
          _buildFilterChip('Sale'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(
        () => GestureDetector(
          onTap: () => selectedCategory.value = label,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  selectedCategory.value == label ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    selectedCategory.value == label
                        ? Colors.black
                        : Colors.grey.shade300,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color:
                    selectedCategory.value == label
                        ? Colors.white
                        : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetConfig.searchIcon,
            height: 70,
            width: 70,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade300,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter to find what you\'re looking for',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: productController.products.length,
      itemBuilder: (context, index) {
        final product = productController.products[index];
        return GestureDetector(
          onTap: () => Get.toNamed('/product-details', arguments: product.id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Product image
                        Image.asset(
                          product.images[0].replaceAll('asset://', ''),
                          fit: BoxFit.cover,
                        ),
                        // Favorite button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap:
                                () => productController.toggleFavorite(
                                  product.id,
                                ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                product.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    product.isFavorite
                                        ? Colors.red
                                        : Colors.grey.shade600,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Product details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' (${product.reviewCount})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilterChips() {
    List<String> categories = [
      'All',
      'Clothing',
      'Care',
      'Decoration',
      'Tops',
      'Shorts',
      'Coats',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          categories
              .map(
                (category) => Obx(
                  () => GestureDetector(
                    onTap: () => selectedCategory.value = category,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selectedCategory.value == category
                                ? Colors.black
                                : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color:
                              selectedCategory.value == category
                                  ? Colors.black
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                              selectedCategory.value == category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        Obx(
          () => RangeSlider(
            values: RangeValues(minPrice.value, maxPrice.value),
            min: 0,
            max: 500,
            divisions: 50,
            activeColor: Colors.black,
            inactiveColor: Colors.grey.shade200,
            labels: RangeLabels(
              '\$${minPrice.value.toInt()}',
              '\$${maxPrice.value.toInt()}',
            ),
            onChanged: (RangeValues values) {
              minPrice.value = values.start;
              maxPrice.value = values.end;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  '\$${minPrice.value.toInt()}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              Obx(
                () => Text(
                  '\$${maxPrice.value.toInt()}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    List<String> sortOptions = ['New Today', 'Top Sellers', 'New collection'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          sortOptions
              .map(
                (option) => Obx(
                  () => GestureDetector(
                    onTap: () => sortBy.value = option,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            sortBy.value == option
                                ? Colors.black
                                : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color:
                              sortBy.value == option
                                  ? Colors.black
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color:
                              sortBy.value == option
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 5; i >= 1; i--)
          GestureDetector(
            onTap:
                () => selectedRating.value = selectedRating.value == i ? 0 : i,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Obx(
                    () => Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color:
                              selectedRating.value == i
                                  ? Colors.black
                                  : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child:
                          selectedRating.value == i
                              ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(
                      i,
                      (index) =>
                          Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
