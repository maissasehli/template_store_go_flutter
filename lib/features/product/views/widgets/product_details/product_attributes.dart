// product_attributes.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';

class ProductAttributes extends StatelessWidget {
  final ProductDetailControllerImp controller;
  
  const ProductAttributes({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 0,
            left: 0,
            child: Text(
              'Size',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 0,
            child: SizeSelector(controller: controller),
          ),

          // Color selector
          Positioned(
            top: 0,
            right: 0,
            child: ColorSelector(controller: controller),
          ),
        ],
      ),
    );
  }
}

class SizeSelector extends StatelessWidget {
  final ProductDetailControllerImp controller;
  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  
  SizeSelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) => _buildSizeOption(context, size)).toList(),
    );
  }

  Widget _buildSizeOption(BuildContext context, String size) {
    return Obx(() {
      final selectedSize = controller.selectedSize.value;
      
      return GestureDetector(
        onTap: () {
          controller.selectSize(size);
        },
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedSize == size ? Colors.black : Colors.white,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: selectedSize == size ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ColorSelector extends StatelessWidget {
  final ProductDetailControllerImp controller;
  final Map<String, Color> colorOptions = {
    'White': Colors.white,
    'Black': Colors.black,
    'Green': Colors.green,
    'Orange': Colors.orange,
  };
  
  ColorSelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: colorOptions.entries.map((entry) {
          return _buildColorOption(entry.value, entry.key);
        }).toList(),
      ),
    );
  }

  Widget _buildColorOption(Color color, String colorName) {
    return Obx(() {
      final selectedColor = controller.selectedColor.value;
      final isSelected = selectedColor == colorName;
      
      return GestureDetector(
        onTap: () {
          controller.selectColor(colorName);
        },
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: color == Colors.white
                ? Border.all(color: Colors.grey[300]!)
                : null,
          ),
          child: isSelected
              ? Center(
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: color == Colors.white ? Colors.black : Colors.white,
                  ),
                )
              : null,
        ),
      );
    });
  }
}