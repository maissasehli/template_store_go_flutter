import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/app/core/config/assets_config.dart';

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
            AssetConfig.discountShape,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(Colors.green[400]!, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
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
                color: widget.isLoading ? Colors.grey : Colors.black,
                shape: BoxShape.circle,
              ),
              child: widget.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        AssetConfig.arrowRight2,
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