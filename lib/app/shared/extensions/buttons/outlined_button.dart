import 'package:flutter/material.dart';
import 'package:store_go/app/core/config/theme/ui_config.dart';
import 'package:store_go/app/core/config/theme/app_color_extension.dart';

extension StyledButton on Widget {
  Widget outlinedButton(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: UIConfig.fontSizeMedium,
          fontWeight: FontWeight.w500,
        ),
        foregroundColor: colors?.primary,
        side: BorderSide(color: colors?.primary ?? Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        ),
        padding: const EdgeInsets.symmetric(vertical: UIConfig.paddingMedium),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors?.primary ?? Colors.blue,
                  ),
                ),
              )
              : this,
    );
  }
}
