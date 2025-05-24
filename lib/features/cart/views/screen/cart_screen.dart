import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';
import 'package:store_go/features/cart/controllers/cart_controller.dart';
import 'package:store_go/features/cart/views/screen/checkout_screen.dart';
import 'package:store_go/features/cart/views/widgets/cart_item_card.dart';
import 'package:store_go/features/cart/views/widgets/cart_summary.dart';
import 'package:store_go/features/cart/views/widgets/coupon_field.dart';
import 'package:store_go/app/core/localization/translation_extension.dart';
import 'package:store_go/app/core/localization/localization_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final bool isRtl = LocalizationService.isRtl(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.background(context),
        elevation: 0,
        leading: IconButton(
          icon: ThemeAwareSvg(
            assetPath: isRtl ? AssetConfig.arrowRight : AssetConfig.arrowLeft,
            height: 24,
            width: 24,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'cart.title'.translate(),
          style: LocalizationService.getLocalizedTextStyle(
            context,
            TextStyle(
              color: AppColors.foreground(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.foreground(context)),
            onSelected: (value) {
              if (value == 'clear_cart') {
                // Show confirmation dialog before clearing cart
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'cart.clear_cart'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(
                          color: AppColors.foreground(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    content: Text(
                      'cart.clear_cart_confirmation'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(color: AppColors.mutedForeground(context)),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'cart.cancel'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              color: AppColors.mutedForeground(context),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          cartController.clearCart();
                        },
                        child: Text(
                          'cart.clear'.translate(),
                          style: LocalizationService.getLocalizedTextStyle(
                            context,
                            TextStyle(
                              color: AppColors.destructive(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'clear_cart',
                    child: Text(
                      'cart.clear_cart'.translate(),
                      style: LocalizationService.getLocalizedTextStyle(
                        context,
                        TextStyle(color: AppColors.destructive(context)),
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary(context)),
          );
        }

        if (cartController.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cartController.errorMessage.value.isNotEmpty
                      ? cartController.errorMessage.value
                      : 'cart.load_error'.translate(),
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground(context),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cartController.fetchCartItems(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    foregroundColor: AppColors.primaryForeground(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'cart.try_again'.translate(),
                    style: LocalizationService.getLocalizedTextStyle(
                      context,
                      TextStyle(color: AppColors.primaryForeground(context)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return cartController.cartItems.isEmpty
            ? _buildEmptyCart(context)
            : _buildCartWithItems(context, cartController);
      }),
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
            'cart.empty_cart'.translate(),
            style: LocalizationService.getLocalizedTextStyle(
              context,
              TextStyle(
                color: AppColors.foreground(context),
                fontSize: UIConfig.fontSizeLarge,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
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
            child: Text(
              'cart.explore_categories'.translate(),
              style: LocalizationService.getLocalizedTextStyle(
                context,
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(BuildContext context, CartController controller) {
    final bool isRtl = LocalizationService.isRtl(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UIConfig.paddingLarge),
      child: Column(
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchCartItems();
                },
                color: AppColors.primary(context),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children:
                        controller.cartItems.map((item) {
                          return CartItemCard(
                            item: item,
                            onQuantityChanged:
                                (quantity) =>
                                    controller.updateCartItemQuantityOptimistic(
                                      item.id,
                                      quantity,
                                    ),
                            onRemove:
                                () => controller.removeCartItemOptimistic(
                                  item.id,
                                ),
                          );
                        }).toList(),
                  ),
                ),
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
                  '${'cart.checkout'.translate()} (\$${controller.total.value.toStringAsFixed(2)})',
                  style: LocalizationService.getLocalizedTextStyle(
                    context,
                    TextStyle(
                      color: AppColors.primaryForeground(context),
                      fontSize: UIConfig.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
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
