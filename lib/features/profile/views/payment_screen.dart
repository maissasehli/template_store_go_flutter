import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

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
            
            // Cards Title
            const Text(
              'Cards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Gabarito',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Card 1
            _buildCreditCard('**** 4187', true),
            const SizedBox(height: 12),
            
            // Card 2
            _buildCreditCard('**** 9387', true),
            const SizedBox(height: 24),
            
            // Paypal Title
            const Text(
              'Paypal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Gabarito',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Paypal Account
            _buildPaypalAccount('Cloth@gmail.com'),
            
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
          onPressed: () => Get.toNamed('/add-cart'),
        ),
      ),
    );
  }

  Widget _buildCreditCard(String cardNumber, bool isMastercard) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Mastercard icon (red circle)
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Card number
          Text(
            cardNumber,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          // Arrow right
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildPaypalAccount(String email) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    );
  }
}