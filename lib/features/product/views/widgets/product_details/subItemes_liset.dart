// subitems_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';
import 'package:store_go/features/product/views/widgets/product_details/price_counter.dart';

class SubItemsList extends GetView<ProductDetailControllerImp> {
  const SubItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add-Ons',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        
        // This would typically come from a list of add-ons in your product model
        // For demonstration, I'm creating some static items
        _buildSubItem(
          "Extra Size Portion", 
          "2.99", 
          "0", 
          () => print("Add extra size"), 
          () => print("Remove extra size")
        ),
        
        const Divider(height: 24),
        
        _buildSubItem(
          "Extra Cheese", 
          "1.50", 
          "0", 
          () => print("Add cheese"), 
          () => print("Remove cheese")
        ),
        
        const Divider(height: 24),
        
        _buildSubItem(
          "Special Sauce", 
          "0.99", 
          "0", 
          () => print("Add sauce"), 
          () => print("Remove sauce")
        ),
      ],
    );
  }
  
  Widget _buildSubItem(String name, String price, String count, Function()? onAdd, Function()? onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        PriceAndCountItems(
          price: price,
          count: count,
          onAdd: onAdd,
          onRemove: onRemove,
        ),
      ],
    );
  }
}