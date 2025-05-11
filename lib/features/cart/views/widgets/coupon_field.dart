import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';


class CouponField extends StatefulWidget {
  final Function(String) onApplyCoupon;
  final String? initialValue;
  final bool isLoading;

  const CouponField({
    super.key,
    required this.onApplyCoupon,
    this.initialValue,
    this.isLoading = false,
  });

  @override
  State<CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends State<CouponField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // Consider replacing with a UIConfig value
      margin: EdgeInsets.only(top: UIConfig.marginMedium),
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      child: Row(
        children: [
          SizedBox(width: UIConfig.paddingMedium),
          SvgPicture.asset(
            AssetConfig.discountShape,
            width: 20,
            height: 20,
          ),
          SizedBox(width: UIConfig.paddingSmall * 1.5), // 12.0
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: UIConfig.fontSizeRegular,
                  color: AppColors.mutedForeground(context),
                  fontFamily: 'Poppins',
                ),
              ),
              style: TextStyle(
                color: AppColors.inputForeground(context),
                fontFamily: 'Poppins',
              ),
              onSubmitted: widget.isLoading ? null : widget.onApplyCoupon,
            ),
          ),
          GestureDetector(
            onTap: widget.isLoading 
                ? null 
                : () => widget.onApplyCoupon(_controller.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.isLoading 
                    ? AppColors.muted(context)
                    : AppColors.primary(context),
                shape: BoxShape.circle,
              ),
              child: widget.isLoading
                  ? Padding(
                      padding: EdgeInsets.all(UIConfig.paddingSmall * 1.25), // 10.0
                      child: CircularProgressIndicator(
                        color: AppColors.mutedForeground(context),
                        strokeWidth: 2,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(UIConfig.paddingSmall * 1.25), // 10.0
                      child: SvgPicture.asset(
                        AssetConfig.arrowRight2,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          AppColors.primaryForeground(context),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: UIConfig.paddingSmall),
        ],
      ),
    );
  }
}