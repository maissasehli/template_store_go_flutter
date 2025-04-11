// product_image_gallery.dart
import 'package:flutter/material.dart';
import 'package:store_go/features/product/controllers/product_detail_controller.dart';

class ProductImageGallery extends StatelessWidget {
  final ProductDetailControllerImp controller;
  final double height;

  const ProductImageGallery({
    Key? key, 
    required this.controller,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[200],
      child: _buildGallery(),
    );
  }

  Widget _buildGallery() {
    final images = controller.getProductImages();
    
    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return PageView.builder(
      itemCount: images.length,
      onPageChanged: (index) {
        controller.selectImage(index);
      },
      itemBuilder: (context, index) {
        final imageUrl = images[index].trim();
        Widget imageWidget;
        
        if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
          imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
        } else {
          imageWidget = Image.asset(imageUrl, fit: BoxFit.cover);
        }
        
        // Apply Hero animation only to the first image
        if (index == 0) {
          return Hero(
            tag: "product-${controller.product.value?.id}",
            child: imageWidget,
          );
        } else {
          return imageWidget;
        }
      },
    );
  }
}