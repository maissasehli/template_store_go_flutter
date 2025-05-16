import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/routes_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';
import 'package:store_go/features/home/views/widgets/product_card.dart';
import 'package:store_go/features/search/controllers/search_controller.dart';
import 'package:store_go/features/search/no_search_result.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({Key? key, required this.initialQuery}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchPageController _searchController = Get.put(
    SearchPageController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      _searchController.searchProducts(widget.initialQuery);
    }
  }

  void _onSearch(String query) {
    _searchController.searchProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorExtension>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: colors.foreground,
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: colors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              initialValue: widget.initialQuery,
              onSearch: _onSearch,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (_searchController.searchQuery.value.isEmpty) {
                return Center(
                  child: Text(
                    'Enter a search term to find products',
                    style: TextStyle(color: colors.mutedForeground),
                  ),
                );
              } else if (_searchController.hasError.value) {
                return Center(
                  child: Text(
                    _searchController.errorMessage.value,
                    style: TextStyle(color: colors.destructive),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!_searchController.hasResults.value) {
                return NoSearchResult(
                  onExploreCategories: () {
                    Get.toNamed(AppRoute.categories);
                  },
                );
              } else {
                return _buildSearchResults();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: _searchController.searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchController.searchResults[index];
          return ProductCard(
            product: product,
            onProductTap: (id) => _searchController.onProductTap(id),
            onFavoriteTap: (id) => _searchController.toggleFavorite(id),
          );
        },
      );
    });
  }
}
