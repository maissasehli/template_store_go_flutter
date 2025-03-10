import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/core/theme/color_extension.dart';

extension StyledButton on Widget {
  Widget secondaryIconTextButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required String icon,
    bool isLoading = false,
    bool iconLeading = true,
    double spacing = 16.0,
    bool alignContentLeft = false, // parameter for left alignment
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
                  SvgPicture.asset(icon, width: 24, height: 24),
                  SizedBox(width: spacing),
                  this,
                ] else ...[
                  this,
                  SizedBox(width: spacing),
                  SvgPicture.asset(icon, width: 24, height: 24),
                ],
              ],
            );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: UIConstants.fontSizeMedium,
          fontWeight: FontWeight.w400,
        ),
        backgroundColor: colors?.secondary,
        foregroundColor: colors?.foreground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusCircular),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.paddingMedium,
          horizontal: UIConstants.paddingLarge,
        ),
        // This alignment property affects the internal alignment of the button's child
        alignment: alignContentLeft ? Alignment.centerLeft : Alignment.center,
      ),
      child: buttonChild,
    );
  }
}
