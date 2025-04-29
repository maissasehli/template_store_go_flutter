
// Header section with Clear, title, and Close button
import 'package:flutter/material.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';
import 'package:store_go/features/subcategory/controllers/subcategory_controller.dart';

class FilterHeader extends StatelessWidget {
  final ProductListController listController;
  final SubcategoryController subcategoryController;

  const FilterHeader({
    super.key,
    required this.listController,
    required this.subcategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              listController.clearFilters();
              subcategoryController.resetState();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const Text(
            'Filter by',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.black, size: 24),
          ),
        ],
      ),
    );
  }
}
