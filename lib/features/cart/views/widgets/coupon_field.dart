import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';
import 'package:store_go/app/core/theme/app_color_utils.dart';
import 'package:store_go/app/core/theme/app_theme_colors.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/shared/widgets/theme_aware_svg.dart';

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
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Adjusted for consistent height
      margin: EdgeInsets.only(top: UIConfig.marginMedium),
      decoration: BoxDecoration(
        color: AppColors.input(context),
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        border: Border.all(
          color: _isFocused ? AppColors.primary(context) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: UIConfig.paddingMedium),
          SvgPicture.asset(
            AssetConfig.discountShape,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              AppColors.mutedForeground(context),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: UIConfig.paddingSmall * 1.5),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true, // Helps with vertical centering
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground(context),
                  fontFamily: 'Poppins',
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.inputForeground(context),
                fontFamily: 'Poppins',
              ),
              onSubmitted: widget.isLoading ? null : widget.onApplyCoupon,
            ),
          ),
          GestureDetector(
            onTap:
                widget.isLoading
                    ? null
                    : () => widget.onApplyCoupon(_controller.text),
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 6),

              child:
                  widget.isLoading
                      ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          color: AppColors.mutedForeground(context),
                          strokeWidth: 2,
                        ),
                      )
                      : Center(
                        child: ThemeAwareSvg(
                          assetPath: AssetConfig.arrowRight,
                          width: 16,
                          height: 16,
                          colorName: AppColorName.foreground,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
