import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:store_go/core/model/home/product_model.dart';

class ProductService {
  final String baseUrl = 'https://your-api-endpoint.com/api';

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // For demo, return dummy products
      return _getDummyProducts();
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/featured'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load featured products: ${response.statusCode}',
        );
      }
    } catch (e) {
      // For demo, return some dummy products
      return _getDummyProducts().sublist(0, 5);
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?category=$categoryId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load products by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      // For demo, filter dummy products by category
      return _getDummyProducts()
          .where((p) => p.category == categoryId)
          .toList();
    }
  }

  // Get product by ID
  Future<Product> getProductById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception(
          'Failed to load product details: ${response.statusCode}',
        );
      }
    } catch (e) {
      // For demo, find product from dummy data
      final product = _getDummyProducts().firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      return product;
    }
  }

  // Update favorite status
  Future<void> updateFavoriteStatus(String productId, bool isFavorite) async {
    try {
      await http.patch(
        Uri.parse('$baseUrl/products/$productId/favorite'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isFavorite': isFavorite}),
      );
    } catch (e) {
      // Just log for demo
      print('Failed to update favorite status: $e');
    }
  }

  // Dummy products for demo - updated to match the reference image
  List<Product> _getDummyProducts() {
    return [
      Product(
        id: '1',
        name: "Men's Harrington Jacket",
        description:
            "Classic Harrington jacket in light green. Made from lightweight cotton with a comfortable fit.",
        price: 184.00,
        images: ['asset://assets/products/product_jacket.png'],
        category: 'clothing',
        variants: {
          'size': ['S', 'M', 'L', 'XL'],
          'color': ['Green', 'Black', 'Blue'],
        },
        rating: 4.8,
        reviewCount: 176,
        isFavorite: false,
      ),
      Product(
        id: '2',
        name: "Max Cirro Men's Slides",
        description:
            "Comfortable slides with cushioned footbed. Perfect for casual wear.",
        price: 59.00,
        images: ['asset://assets/products/product_slides.png'],
        category: 'shoes',
        variants: {
          'size': ['7', '8', '9', '10', '11'],
          'color': ['Black', 'White', 'Navy'],
        },
        rating: 4.5,
        reviewCount: 234,
        isFavorite: true,
      ),
      Product(
        id: '3',
        name: "Men's Fitted T-Shirt",
        description: "Comfortable fitted t-shirt made from 100% cotton.",
        price: 45.00,
        images: ['asset://assets/products/tshirt_white.png'],
        category: 'clothing',
        variants: {
          'size': ['S', 'M', 'L', 'XL'],
          'color': ['White', 'Black', 'Grey', 'Navy'],
        },
        rating: 4.3,
        reviewCount: 142,
        isFavorite: false,
      ),
      Product(
        id: '4',
        name: "Canvas Weekender Bag",
        description:
            "Spacious canvas bag with leather trim, perfect for weekend trips.",
        price: 95.00,
        images: ['asset://assets/products/hoodie_green.png'],
        category: 'bags',
        variants: {
          'size': ['One Size'],
          'color': ['Tan', 'Navy', 'Olive'],
        },
        rating: 4.7,
        reviewCount: 89,
        isFavorite: false,
      ),
      // Add more hoodie products
      Product(
        id: '5',
        name: "Men's Essential Hoodie - Green",
        description: "Comfortable cotton blend hoodie in vibrant green.",
        price: 65.00,
        images: ['asset://assets/products/hoodie_green.png'],
        category: 'hoodie',
        variants: {
          'size': ['S', 'M', 'L', 'XL'],
          'color': ['Green', 'Black', 'Grey'],
        },
        rating: 4.6,
        reviewCount: 128,
        isFavorite: false,
      ),
      Product(
        id: '6',
        name: "Women's Oversized Hoodie - Yellow",
        description:
            "Oversized fit hoodie in bright yellow, perfect for casual wear.",
        price: 72.00,
        images: ['asset://assets/products/hoodie_yellow.png'],
        category: 'hoodie',
        variants: {
          'size': ['XS', 'S', 'M', 'L'],
          'color': ['Yellow', 'Pink', 'White'],
        },
        rating: 4.8,
        reviewCount: 94,
        isFavorite: false,
      ),
      Product(
        id: '7',
        name: "Unisex Tie-Dye Hoodie",
        description: "Vibrant tie-dye pattern on a comfortable cotton hoodie.",
        price: 85.00,
        images: ['asset://assets/products/hoodie_tiedye.png'],
        category: 'hoodie',
        variants: {
          'size': ['S', 'M', 'L', 'XL'],
          'color': ['Multi'],
        },
        rating: 4.5,
        reviewCount: 76,
        isFavorite: false,
      ),
      Product(
        id: '8',
        name: "Men's Black Zip-up Hoodie",
        description: "Classic zip-up hoodie in black, perfect for layering.",
        price: 68.00,
        images: ['asset://assets/products/hoodie_black.png'],
        category: 'hoodie',
        variants: {
          'size': ['S', 'M', 'L', 'XL', 'XXL'],
          'color': ['Black', 'Navy', 'Grey'],
        },
        rating: 4.7,
        reviewCount: 112,
        isFavorite: false,
      ),
    ];
  }
}
