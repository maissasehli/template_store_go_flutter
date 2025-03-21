import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';

extension StyledButton on Widget {
  Widget dangerButton(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    final dangerColor = colors?.destructive ?? Colors.red;
    final dangerForeground = colors?.destructiveForeground ?? Colors.white;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: UIConfig.fontSizeMedium,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: dangerColor,
        foregroundColor: dangerForeground,
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
                  valueColor: AlwaysStoppedAnimation<Color>(dangerForeground),
                ),
              )
              : this,
    );
  }
}
