// Results count widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/product/controllers/product_list_controller.dart';

class ResultsCount extends StatelessWidget {
  final ProductListController listController;

  const ResultsCount({super.key, required this.listController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Text(
          '${listController.products.length} Results Found',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
