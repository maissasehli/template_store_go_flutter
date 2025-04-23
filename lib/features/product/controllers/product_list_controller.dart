import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/product/controllers/product_controller.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/filter/controllers/product_filter_controller.dart';
import 'dart:developer' as developer;

class ProductListController extends GetxController {
  final ProductController productController;
  final ProductFilterController filterController;
  final Logger _logger = Logger();

  // Product list state
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString title = ''.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  ProductListController({
    required this.productController,
    required this.filterController,
  });

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    String listType = 'all';
    if (args != null) {
      title.value = args['title'] ?? 'Products';
      listType = args['listType'] ?? 'all';
    } else {
      title.value = 'Products';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProducts(listType);
    });
    
    // Listen to changes in the product controller's products list
    ever(productController.products, (_) {
      products.assignAll(productController.products);
    });
  }

  Future<void> loadProducts(String listType) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      switch (listType) {
        case 'featured':
          await productController.fetchFeaturedProducts();
          products.assignAll(productController.featuredProducts);
          break;
        case 'new':
          await productController.fetchNewProducts();
          products.assignAll(productController.newProducts);
          break;
        case 'category':
          final categoryId = Get.arguments?['categoryId'] ?? '';
          if (categoryId.isNotEmpty) {
            await productController.fetchProductsByCategory(categoryId);
            products.assignAll(productController.products);
          }
          break;
        case 'subcategory':
          final subcategoryId = filterController.selectedSubcategoryId.value;
          if (subcategoryId.isNotEmpty) {
            await productController.fetchProductsBySubcategory(subcategoryId);
            products.assignAll(productController.products);
          }
          break;
        case 'all':
        default:
          await productController.fetchAllProducts();
          products.assignAll(productController.products);
          break;
      }

      developer.log('Loaded ${products.length} products for list type: $listType',
          name: 'ProductListController.loadProducts');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = productController.errorMessage.value.isNotEmpty
          ? productController.errorMessage.value
          : 'Failed to load products. Please try again.';
      _logger.e('Error loading products: $e');
      developer.log('Error loading products: $e',
          name: 'ProductListController.loadProducts', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    final args = Get.arguments;
    final listType = args?['listType'] ?? 'all';
    await loadProducts(listType);
  }

  Future<void> applyFilters() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      await filterController.applyFilters();
      products.assignAll(productController.products);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to apply filters. Please try again.';
      _logger.e('Error applying filters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearFilters() async {
    try {
      isLoading.value = true;
      await filterController.clearFilters();
      products.assignAll(productController.products);
    } catch (e) {
      _logger.e('Error clearing filters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String productId) {
    productController.toggleFavorite(productId);
    developer.log('Toggled favorite for product $productId',
        name: 'ProductListController.toggleFavorite');
  }

  void onProductTap(String productId) {
    Get.toNamed('/product-details', arguments: {'productId': productId});
    developer.log('Navigated to product details for $productId',
        name: 'ProductListController.onProductTap');
  }
}