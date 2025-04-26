import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:store_go/features/category/models/category.model.dart';
import 'package:store_go/features/product/models/product_model.dart';
import 'package:store_go/features/product/repositories/product_repository.dart';
import 'package:store_go/features/review/controllers/review_controller.dart';

class CategoryProductController extends GetxController {
  final ProductRepository _repository;
  final Logger _logger = Logger();

  // Observable states
  final RxList<Product> categoryProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Category?> currentCategory = Rx<Category?>(null);
  final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;

  CategoryProductController({required ProductRepository repository})
      : _repository = repository;

  void setCategory(Category category) {
    currentCategory.value = category;
    searchQuery.value = '';
    isSearchActive.value = false;
    _logger.d("Category set: ${category.name} (ID: ${category.id})");
    
    // Ne pas vider les produits ici car nous les chargerons ensuite
    // avec fetchCategoryProducts
  }

  Future<void> fetchCategoryProducts(String categoryId) async {
    try {
      print("⭐️ DÉBUT fetchCategoryProducts pour catégorie: $categoryId");
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final products = await _repository.getProductsByCategory(categoryId);
      print("⭐️ REÇU ${products.length} produits pour catégorie $categoryId");

      // Sauvegarder les produits originaux
      categoryProducts.assignAll(products);
      
      // Mettre à jour également les produits filtrés
      filteredProducts.assignAll(products);
      
      print("⭐️ État après mise à jour: ${categoryProducts.length} produits dans la catégorie, ${filteredProducts.length} produits filtrés");
    } catch (e) {
      print("❌ ERREUR dans fetchCategoryProducts: $e");
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error fetching products for category $categoryId: $e');
      categoryProducts.clear();
      filteredProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchCategoryProducts(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      isSearchActive.value = false;
      if (currentCategory.value != null) {
        // Restaurer tous les produits de la catégorie
        filteredProducts.assignAll(categoryProducts);
      }
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      isSearchActive.value = true;

      List<Product> allCategoryProducts;
      if (categoryProducts.isEmpty && currentCategory.value != null) {
        // Si les produits de cette catégorie n'ont pas encore été chargés
        allCategoryProducts = await _repository.getProductsByCategory(currentCategory.value!.id);
      } else {
        // Utiliser les produits déjà chargés
        allCategoryProducts = List.from(categoryProducts);
      }

      final filteredProductsList = allCategoryProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _logger.d("Found ${filteredProductsList.length} products matching '$query' in category ${currentCategory.value?.id}");
      filteredProducts.assignAll(filteredProductsList);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      _logger.e('Error searching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilters({
    required String categoryId,
    required String subcategoryId,
    required double minPrice,
    required double maxPrice,
    required String sortOption,
    required double minRating,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print("🔍 Applying filters - Category: $categoryId, Subcategory: $subcategoryId");

      List<Product> products;
      try {
        // Essayer d'abord le filtrage côté serveur
        products = await _repository.getFilteredProducts(
          categoryId: categoryId.isNotEmpty ? categoryId : null,
          subcategoryId: subcategoryId.isNotEmpty ? subcategoryId : null,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating > 0 ? minRating : null,
          sortOption: sortOption,
        );
        
        print("🔍 Got ${products.length} products from server-side filtering");
      } catch (e) {
        print("⚠️ Server-side filtering failed, falling back to client-side: $e");
        _logger.w('Server-side filtering failed, falling back to client-side: $e');
        
        // Si le filtrage côté serveur échoue, utiliser le filtrage côté client
        if (subcategoryId.isNotEmpty) {
          products = await _repository.getProductsBySubcategory(subcategoryId);
          print("🔍 Fetched ${products.length} products for subcategory $subcategoryId");
        } else {
          products = await _repository.getProductsByCategory(categoryId.isNotEmpty ? categoryId : currentCategory.value!.id);
          print("🔍 Fetched ${products.length} products for category $categoryId");
        }

        // Appliquer le filtrage de prix côté client
        products = products.where((product) {
          return product.price >= minPrice && product.price <= maxPrice;
        }).toList();
        
        print("🔍 After price filter ($minPrice-$maxPrice): ${products.length} products");

        // Appliquer le filtrage de notation si nécessaire
        if (minRating > 0) {
          final reviewController = Get.find<ReviewController>();
          products = await Future.wait(products.map((product) async {
            if (product.rating >= minRating) {
              return product;
            }
            final reviews = await reviewController.getReviewsByProductId(product.id);
            final avgRating = reviews.isNotEmpty
                ? reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviews.length
                : 0.0;
            return avgRating >= minRating ? product : null;
          })).then((results) => results.whereType<Product>().toList());
          
          print("🔍 After rating filter ($minRating): ${products.length} products");
        }

        // Appliquer le tri
        switch (sortOption) {
          case 'New Today':
            products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
          case 'Top Sellers':
            products.sort((a, b) => (b.salesCount ?? 0).compareTo(a.salesCount ?? 0));
            break;
          case 'Price: Low to High':
            products.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'Price: High to Low':
            products.sort((a, b) => b.price.compareTo(a.price));
            break;
        }
      }

      // Mettre à jour les deux listes
      categoryProducts.assignAll(products);
      filteredProducts.assignAll(products);
      
      print("✅ Applied filters: ${products.length} products found and displayed");
      _logger.i('Applied filters: ${products.length} products found');
    } catch (e) {
      print("❌ Error applying filters: $e");
      hasError.value = true;
      errorMessage.value = 'Failed to apply filters: $e';
      _logger.e('Error applying filters: $e');
      filteredProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final productIndex = filteredProducts.indexWhere((p) => p.id == productId);
    if (productIndex == -1) return;

    final product = filteredProducts[productIndex];
    final newFavoriteStatus = !product.isFavorite;

    filteredProducts[productIndex] = product.copyWith(isFavorite: newFavoriteStatus);
    final categoryIndex = categoryProducts.indexWhere((p) => p.id == productId);
    if (categoryIndex != -1) {
      categoryProducts[categoryIndex] = product.copyWith(isFavorite: newFavoriteStatus);
    }

    try {
      final success = await _repository.updateFavoriteStatus(productId, newFavoriteStatus);
      if (!success) {
        filteredProducts[productIndex] = product;
        if (categoryIndex != -1) {
          categoryProducts[categoryIndex] = product;
        }
        _logger.e('Server rejected favorite status update');
      }
    } catch (e) {
      filteredProducts[productIndex] = product;
      if (categoryIndex != -1) {
        categoryProducts[categoryIndex] = product;
      }
      _logger.e('Error updating favorite status: $e');
    }
  }

  void clearSearch() {
    if (isSearchActive.value && currentCategory.value != null) {
      searchQuery.value = '';
      isSearchActive.value = false;
      filteredProducts.assignAll(categoryProducts);
    }
  }

  @override
  void onClose() {
    _logger.d("CategoryProductController closed");
    super.onClose();
  }
}