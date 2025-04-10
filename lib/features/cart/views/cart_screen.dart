import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetX to inject and initialize the controller
final controller = Get.put(CartControllerImp());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => controller.cartItems.isEmpty 
          ? _buildEmptyCart(controller) 
          : _buildCartWithItems(controller)),
      ),
    );
  }

  Widget _buildEmptyCart(CartController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bag icon in a circle with enhanced shadow
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(70),
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
                AssetConfig.panierIcon,
                width: 48,
                height: 48,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Empty cart text
          const Text(
            'Your Panier is Empty',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),

          // Explore Categories button
          ElevatedButton(
            onPressed: controller.navigateToCategories,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              minimumSize: const Size(188, 55),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(CartController controller) {
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
                onTap: controller.goBack,
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
                    'Panier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40), // Balance the layout
            ],
          ),
          const SizedBox(height: 20),

          // Cart items list
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return _buildCartItemCard(item, index, controller);
              },
            )),
          ),

          // Cart summary
          _buildCartSummary(controller),

          // Coupon code field
          _buildCouponField(controller),

          // Checkout button
          Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.only(bottom: 24, top: 16),
            child: ElevatedButton(
              onPressed: controller.navigateToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, int index, CartController controller) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart, // Only allow right to left swipe
      confirmDismiss: (direction) async {
        // Don't actually dismiss the item when swiped
        controller.confirmItemRemoval(index);
        return false;
      },
      background: Container(
        color: Colors.transparent, // Make the background transparent
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(13.76),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: SvgPicture.asset(
            AssetConfig.delete,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 105.87,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.76),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 25.41,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13.76),
                bottomLeft: Radius.circular(13.76),
              ),
              child: Image.asset(
                item.imageUrl,
                width: 80,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quantity controls
            Container(
              width: 74.11,
              height: 31.76,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(31.76),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Minus button
                  GestureDetector(
                    onTap: () => controller.updateQuantity(index, -1),
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Quantity
                  SizedBox(
                    width: 24,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Plus button
                  GestureDetector(
                    onTap: () => controller.updateQuantity(index, 1),
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: Icon(Icons.add, size: 16, color: Colors.black),
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

  Widget _buildCartSummary(CartController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Obx(() => Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${controller.subtotal.toStringAsFixed(0)}'),
          _buildSummaryRow('Shipping Cost', '\$${controller.shippingCost.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax', '\$${controller.tax.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Total',
            '\$${controller.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      )),
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

  Widget _buildCouponField(CartController controller) {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          SvgPicture.asset(
            AssetConfig.discountshape,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.green[400]!, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: controller.onCouponCodeChanged,
              decoration: const InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.applyCoupon,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  AssetConfig.arrowright2,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}