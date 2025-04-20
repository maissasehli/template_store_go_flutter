import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/features/payment/controller/payment_controller.dart';
import 'package:store_go/features/payment/view/widget/payment_item.dart';


class PaymentPage extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            
            Obx(() {
              // Get card payment methods
              final cardMethods = controller.paymentMethods
                  .where((method) => method.type == 'card')
                  .toList();
              
              return cardMethods.isNotEmpty
                  ? _buildPaymentSection('Cards', cardMethods)
                  : const SizedBox.shrink();
            }),
            
            const SizedBox(height: 24),
            
            Obx(() {
              // Get PayPal payment methods
              final paypalMethods = controller.paymentMethods
                  .where((method) => method.type == 'paypal')
                  .toList();
              
              return paypalMethods.isNotEmpty
                  ? _buildPaymentSection('Paypal', paypalMethods)
                  : const SizedBox.shrink();
            }),
            
            // Bottom navigation indicator
            const Spacer(),
            Center(
              child: Container(
                width: 134,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 57,
        height: 57,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(28.5),
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 24),
          onPressed: () => Get.toNamed('/add-payment'),
        ),
      ),
    );
  }

  Widget _buildPaymentSection(String title, List<PaymentMethodModel> methods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Gabarito',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        // Payment Methods List
        ...methods.map((method) {
          return Column(
            children: [
              PaymentItemWidget(
                paymentMethod: method,
                onTap: () => Get.toNamed('/edit-payment', arguments: method),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }
}