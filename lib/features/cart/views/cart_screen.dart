import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/views/widgets/cart_item_card.dart';
import 'package:store_go/features/cart/views/widgets/cart_summary.dart';
import 'package:store_go/features/cart/views/widgets/coupon_field.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (cartController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartController.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    cartController.errorMessage.value.isNotEmpty
                        ? cartController.errorMessage.value
                        : 'An error occurred',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => cartController.fetchCartItems(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return cartController.cartItems.isEmpty
              ? _buildEmptyCart()
              : _buildCartWithItems(cartController);
        }),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/categories');
            },
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
          Row(
            children: [
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
                    'Panier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemCard(
                    item: item,
                    onQuantityChanged: (quantity) =>
                        controller.updateQuantity(item.productId, quantity),
                    onRemove: () => controller.removeFromCart(item.productId),
                  );
                },
              );
            }),
          ),
          Obx(() => CartSummary(
                subtotal: controller.subtotal.value,
                shippingCost: controller.shipping.value,
                tax: controller.tax.value,
                discount: controller.discount.value,
                total: controller.total.value,
                couponCode: controller.couponCode.value.isNotEmpty
                    ? controller.couponCode.value
                    : null,
              )),
          Obx(() => CouponField(
                onApplyCoupon: controller.applyCoupon,
                initialValue: controller.couponCode.value,
                isLoading: controller.isLoading.value,
              )),
          Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.only(bottom: 24, top: 16),
            child: ElevatedButton(
              onPressed: controller.cartItems.isEmpty
                  ? null
                  : () {
                      Get.toNamed('/checkout');
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Obx(() => Text(
                    'Checkout (\$${controller.total.value.toStringAsFixed(2)})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}