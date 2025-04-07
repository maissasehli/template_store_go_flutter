import 'package:flutter/material.dart';
import 'package:store_go/app/core/theme/ui_config.dart';
import 'package:store_go/app/core/theme/app_color_extension.dart';

extension StyledButton on Widget {
  Widget secondaryIconTextButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required Widget icon,
    bool isLoading = false,
    bool iconLeading = true,
    double spacing = 16.0,
    bool alignContentLeft = false, required bool enabled, // parameter for left alignment
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    final buttonChild =
        isLoading
            ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colors?.primaryForeground ?? Colors.white,
                ),
              ),
            )
            : Row(
              // Using mainAxisSize.min creates a tight-fitting row
              // Using mainAxisAlignment controls the placement within the button
              mainAxisSize:
                  alignContentLeft ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment:
                  alignContentLeft
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
              children: [
                if (iconLeading) ...[
                  icon,
                  SizedBox(width: spacing),
                  this,
                ] else ...[
                  this,
                  SizedBox(width: spacing),
                  icon,
                ],
              ],
            );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: UIConfig.fontSizeMedium,
          fontWeight: FontWeight.w400,
        ),
        backgroundColor: colors?.secondary,
        foregroundColor: colors?.foreground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusCircular),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: UIConfig.paddingMedium,
          horizontal: UIConfig.paddingLarge,
        ),
        // This alignment property affects the internal alignment of the button's child
        alignment: alignContentLeft ? Alignment.centerLeft : Alignment.center,
      ),
      child: buttonChild,
    );
  }
}
