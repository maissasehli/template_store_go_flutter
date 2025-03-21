import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // State variables
  bool isOrderPlaced = false;
  String? shippingAddress;
  String? paymentMethod;

  // These values would normally come from your cart
  final double subtotal = 200.0;
  final double shippingCost = 8.0;
  final double tax = 0.0;
  double get total => subtotal + shippingCost + tax;

  void placeOrder() {
    setState(() {
      isOrderPlaced = true;
    });
    // In a real app, you would send the order to your backend here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isOrderPlaced ? _buildOrderConfirmation() : _buildCheckoutForm(),
      ),
    );
  }

  Widget _buildCheckoutForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Back button and title
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gabarito',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40), // Balance the layout
            ],
          ),

          const SizedBox(height: 30),

          // Shipping Address
          Container(
            width: 342,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF4F4F4)),
            ),
            child: ListTile(
              title: const Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                shippingAddress ?? 'Add Shipping Address',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // In a real app, you would show an address form
                setState(() {
                  shippingAddress = '2715 Ash Dr, San Jose, South Dakota';
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Payment Method
          Container(
            width: 342,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF4F4F4)),
            ),
            child: ListTile(
              title: const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                paymentMethod ?? 'Add Payment Method',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // In a real app, you would show a payment form
                setState(() {
                  paymentMethod = '**** 4187';
                });
              },
            ),
          ),

          const Spacer(),

          // Order Summary
          Container(
            width: 342,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  '\$${subtotal.toStringAsFixed(0)}',
                ),
                _buildSummaryRow(
                  'Shipping Cost',
                  '\$${shippingCost.toStringAsFixed(2)}',
                ),
                _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                _buildSummaryRow(
                  'Total',
                  '\$${total.toStringAsFixed(0)}',
                  isTotal: true,
                ),
              ],
            ),
          ),

          // Place Order Button
          Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.only(top: 24, bottom: 24),
            child: ElevatedButton(
              onPressed:
                  shippingAddress != null && paymentMethod != null
                      ? placeOrder
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Place Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderConfirmation() {
    return Scaffold(
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: 140,
            left: 120,
            child: Container(
              width: 15.42,
              height: 15.65,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: 140,
            child: Container(
              width: 7.82,
              height: 8.61,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 150,
            child: Container(
              width: 7.82,
              height: 8.61,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: 160,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Checkmark icon in a circle
                  Container(child: SvgPicture.asset(AssetConfig.Success)),

                  // Success message
                  const Text(
                    'Order Placed\nSuccessfully',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Email confirmation text
                  const Text(
                    'You will recieve an email\nconfirmation',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Leave a comment button
                  Container(
                    width: 342,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // Show comment dialog
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green[700],
                        size: 20,
                      ),
                      label: Text(
                        'Laissez un commentaire',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // See Order Details button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to order details
                          Get.toNamed('/order-details');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          'See Order details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom indicator
                  Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
