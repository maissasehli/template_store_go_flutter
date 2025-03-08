import 'package:flutter/material.dart';
import 'package:store_go/core/constants/ui.dart';
import 'package:store_go/core/theme/color_extension.dart';

/// Extension to create app-styled buttons more easily
extension StyledButtons on Widget {
  /// Creates a primary action button with consistent styling
  Widget primaryButton(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors?.primary,
        foregroundColor: colors?.primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.paddingMedium,
        ),
      ),
      child: isLoading
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
          : this,
    );
  }

  Widget secondaryButton(
    BuildContext context, {
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final colors = Theme.of(context).extension<AppColorExtension>();
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors?.secondary,
        foregroundColor: colors?.secondaryForeground,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colors?.secondaryForeground ?? Colors.white,
                ),
              ),
            )
          : this,
    );
  }
}
