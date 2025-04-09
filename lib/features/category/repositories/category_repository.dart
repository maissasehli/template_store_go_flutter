
import 'package:store_go/features/category/models/category.modal.dart';
import 'package:store_go/features/category/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService;

  // Optional: Add caching mechanism
  List<Category>? _cachedCategories;
  DateTime? _lastFetchTime;

  CategoryRepository(this._categoryService);

  Future<List<Object>> getCategories({bool forceRefresh = false}) async {
    // If we have cached data and it's not expired (and not forcing refresh)
    if (_cachedCategories != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 30 &&
        !forceRefresh) {
      return _cachedCategories!;
    }

    // Otherwise fetch fresh data
    try {
      final categories = await _categoryService.getCategories();

      // Update cache
      _cachedCategories = categories.cast<Category>();
      _lastFetchTime = DateTime.now();

      return categories;
    } catch (e) {
      // Rethrow with more context if needed
      rethrow;
    }
  }

  Future<Object> getCategoryById(String id) async {
    // Check if category exists in cache first
    if (_cachedCategories != null) {
      final cachedCategory = _cachedCategories!.firstWhere(
        (category) => category.id == id,
        orElse:
            () =>
                
                // ignore: cast_from_null_always_fails
                null
                    as Category, // This will properly trigger the exception path
      );

      if (cachedCategory != null) {
        return cachedCategory;
      }
    }

    // Fetch from service if not in cache
    return _categoryService.getCategoryById(id);
  }
}
