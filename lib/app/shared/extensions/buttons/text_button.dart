import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/ui_config.dart';
import 'package:store_go/app/core/config/theme/app_color_extension.dart';

extension StyledButton on Widget {
  Widget textButton(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: UIConfig.fontSizeMedium,
          fontWeight: FontWeight.w400,
        ),
        foregroundColor: colors?.primary,
        padding: const EdgeInsets.symmetric(horizontal: UIConfig.paddingSmall),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors?.primary ?? Colors.white,
                  ),
                ),
              )
              : this,
    );
  }
}
