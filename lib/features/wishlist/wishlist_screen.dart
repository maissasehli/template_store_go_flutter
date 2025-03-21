import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/shared/controllers/navigation_controller.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/home/views/widgets/search_bar.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Sample data for wishlist items
  final List<Map<String, dynamic>> _allWishlistItems = [
    {
      'name': 'Roller Rabbit',
      'description': 'Vado Odelle Dress',
      'price': '\$198.00',
      'quantity': 1,
      'isSelected': true,
    },
    {
      'name': 'Roller Rabbit',
      'description': 'Vado Odelle Dress',
      'price': '\$198.00',
      'quantity': 1,
      'isSelected': false,
    },
    {
      'name': 'Roller Rabbit',
      'description': 'Vado Odelle Dress',
      'price': '\$198.00',
      'quantity': 1,
      'isSelected': false,
    },
    {
      'name': 'Roller Rabbit',
      'description': 'Vado Odelle Dress',
      'price': '\$198.00',
      'quantity': 1,
      'isSelected': false,
    },
    {
      'name': 'Roller Rabbit',
      'description': 'Vado Odelle Dress',
      'price': '\$198.00',
      'quantity': 1,
      'isSelected': false,
    },
  ];

  // Filtered items based on search
  List<Map<String, dynamic>> _filteredWishlistItems = [];

  // Flag to toggle between empty state and items state
  bool _hasWishlistItems = true;

  @override
  void initState() {
    super.initState();
    _filteredWishlistItems = _allWishlistItems;
  }

  // Filter items based on search text
  void _filterItems(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredWishlistItems = _allWishlistItems;
      } else {
        _filteredWishlistItems =
            _allWishlistItems
                .where(
                  (item) =>
                      item['name'].toLowerCase().contains(
                        searchText.toLowerCase(),
                      ) ||
                      item['description'].toLowerCase().contains(
                        searchText.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  // Method to update item quantity
  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQuantity = _filteredWishlistItems[index]['quantity'] + delta;
      if (newQuantity > 0) {
        _filteredWishlistItems[index]['quantity'] = newQuantity;
      }
    });
  }

  // Method to remove item from wishlist - completely reworked
  void _removeItem(int index) {
    // First, validate the index is in range
    if (index < 0 || index >= _filteredWishlistItems.length) {
      return; // Early return if index is invalid
    }

    // Store a copy of the item to be removed
    final Map<String, dynamic> itemToRemove = Map<String, dynamic>.from(
      _filteredWishlistItems[index],
    );

    // Use Future.microtask to defer the state change until after the current event completes
    Future.microtask(() {
      // Safely update state
      setState(() {
        try {
          // Create new lists instead of modifying existing ones
          final newAllItems = List<Map<String, dynamic>>.from(
            _allWishlistItems,
          );
          final newFilteredItems = List<Map<String, dynamic>>.from(
            _filteredWishlistItems,
          );

          // Find and remove from original list
          newAllItems.removeWhere(
            (item) =>
                item['name'] == itemToRemove['name'] &&
                item['description'] == itemToRemove['description'],
          );

          // Remove from filtered list
          newFilteredItems.removeAt(index);

          // Update state with new lists
          _allWishlistItems.clear();
          _allWishlistItems.addAll(newAllItems);

          _filteredWishlistItems.clear();
          _filteredWishlistItems.addAll(newFilteredItems);

          // Update empty state
          _hasWishlistItems = _allWishlistItems.isNotEmpty;
        } catch (e) {
          print('Error during item removal: $e');
          // Force UI refresh to stable state if there's an error
          _filteredWishlistItems = List<Map<String, dynamic>>.from(
            _allWishlistItems,
          );
          _hasWishlistItems = _allWishlistItems.isNotEmpty;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _hasWishlistItems = _allWishlistItems.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body:
          _hasWishlistItems ? _buildWishlistWithItems() : _buildEmptyWishlist(),
    );
  }

  Widget _buildWishlistWithItems() {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Using your CustomSearchBar component
        CustomSearchBar(onSearch: _filterItems),
        const SizedBox(height: 40),
        // Wishlist items
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                _filteredWishlistItems.isEmpty
                    ? const Center(
                      child: Text('No matching items found'),
                    ) // Show "no results" instead of empty state
                    : ListView.builder(
                      key: ValueKey(
                        _filteredWishlistItems.length,
                      ), // Add a key to rebuild ListView when length changes
                      itemCount: _filteredWishlistItems.length,
                      itemBuilder: (context, index) {
                        return _buildWishlistItem(index);
                      },
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistItem(int index) {
    final item = _filteredWishlistItems[index];
    final bool isSelected = item['isSelected'] ?? false;

    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: 325,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          // Shadow appears only when the item is selected
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 11),
                      blurRadius: 24,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
          // Remove the blue border completely
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/products/tshirt_white.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),

            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),

                        // Product description
                        Text(
                          item['description'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    // Price
                    Text(
                      item['price'],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right side: Close button and quantity controls
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Close button
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: () => _removeItem(index),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // Quantity controls
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Minus button
                          GestureDetector(
                            onTap: () => _updateQuantity(index, -1),
                            child: const Icon(Icons.remove, size: 16),
                          ),

                          // Quantity
                          Text(
                            item['quantity'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Plus button
                          GestureDetector(
                            onTap: () => _updateQuantity(index, 1),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heart icon with circular background and gray shadow
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF686868).withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 26.1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AssetConfig.heartIcon,
                width: 47,
                height: 44.65,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // No wishlist yet text
          const Text(
            'No wishlist yet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Explore Categories button
          ElevatedButton(
            onPressed: () {
              // Get the navigation controller and navigate to categories
              final navController = Get.find<NavigationController>();
              navController.changeTab(0); // Go to home tab first
              Get.toNamed('/categories'); // Then navigate to categories
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
