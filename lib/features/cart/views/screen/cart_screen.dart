import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/views/screen/checkout_screen.dart';
import 'package:store_go/features/cart/views/widgets/cart_item_card.dart';
import 'package:store_go/features/cart/views/widgets/cart_summary.dart';
import 'package:store_go/features/cart/views/widgets/coupon_field.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Obx(() {
          if (cartController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
              ),
            );
          }

          if (cartController.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.destructive(context),
                  ),
                  SizedBox(height: UIConfig.marginMedium),
                  Text(
                    cartController.errorMessage.value.isNotEmpty
                        ? cartController.errorMessage.value
                        : 'An error occurred',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.destructive(context)),
                  ),
                  SizedBox(height: UIConfig.marginMedium),
                  ElevatedButton(
                    onPressed: () => cartController.fetchCartItems(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      foregroundColor: AppColors.primaryForeground(context),
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConfig.paddingLarge,
                        vertical: UIConfig.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          UIConfig.borderRadiusCircular,
                        ),
                      ),
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return cartController.cartItems.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartWithItems(context, cartController);
        }),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              color: AppColors.background(context),
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mutedForeground(context).withOpacity(0.2),
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
                colorFilter: ColorFilter.mode(
                  AppColors.foreground(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(height: UIConfig.marginLarge),
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              color: AppColors.foreground(context),
              fontSize: UIConfig.fontSizeLarge,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: UIConfig.marginLarge),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/categories');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: AppColors.primaryForeground(context),
              padding: EdgeInsets.symmetric(
                horizontal: UIConfig.paddingLarge,
                vertical: UIConfig.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  UIConfig.borderRadiusCircular,
                ),
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

  Widget _buildCartWithItems(BuildContext context, CartController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: UIConfig.marginMedium),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary(context),
                    shape: BoxShape.circle,
                  ),
                  child: ThemeAwareSvg(
                    assetPath: AssetConfig.backArrow,
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: UIConfig.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppColors.foreground(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          SizedBox(height: UIConfig.marginMedium),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemCard(
                    item: item,
                    onQuantityChanged:
                        (quantity) =>
                            controller.updateQuantity(item.productId, quantity),
                    onRemove: () => controller.removeFromCart(item.productId),
                  );
                },
              );
            }),
          ),
          Obx(
            () => CartSummary(
              subtotal: controller.subtotal.value,
              shippingCost: controller.shipping.value,
              tax: controller.tax.value,
              discount: controller.discount.value,
              total: controller.total.value,
              couponCode:
                  controller.couponCode.value.isNotEmpty
                      ? controller.couponCode.value
                      : null,
            ),
          ),
          Obx(
            () => CouponField(
              onApplyCoupon: controller.applyCoupon,
              initialValue: controller.couponCode.value,
              isLoading: controller.isLoading.value,
            ),
          ),
          Container(
            width: double.infinity,
            height: 55,
            margin: EdgeInsets.only(
              bottom: UIConfig.marginLarge,
              top: UIConfig.marginMedium,
            ),
            child: ElevatedButton(
              onPressed:
                  controller.cartItems.isEmpty
                      ? null
                      : () {
                        Get.to(() => const CheckoutScreen());
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: AppColors.primaryForeground(context),
                disabledBackgroundColor: AppColors.muted(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    UIConfig.borderRadiusCircular,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
              ),
              child: Obx(
                () => Text(
                  'Checkout (\$${controller.total.value.toStringAsFixed(2)})',
                  style: TextStyle(
                    color: AppColors.primaryForeground(context),
                    fontSize: UIConfig.fontSizeMedium,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
