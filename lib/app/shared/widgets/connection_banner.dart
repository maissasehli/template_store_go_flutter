import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_go/app/core/services/connection_service.dart';

/// A reusable widget that displays a connection status banner.
///
/// This widget shows a banner at the top of the screen when the device
/// is offline. It handles proper spacing with the status bar and provides
/// consistent styling throughout the app.
class ConnectionBanner extends StatelessWidget {
  /// Creates a connection banner.
  ///
  /// The [considerStatusBar] parameter determines whether the widget should
  /// account for the status bar height. Set to true when used at the top of
  /// the screen, false when used within other UI components.
  final bool considerStatusBar;

  /// The color of the banner when offline.
  final Color? bannerColor;

  /// The icon to display in the banner.
  final IconData? icon;

  /// The text to display in the banner.
  final String? message;

  const ConnectionBanner({
    Key? key,
    this.considerStatusBar = false,
    this.bannerColor,
    this.icon,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectionService = Get.find<ConnectionService>();

    // Get status bar height if needed
    final statusBarHeight =
        considerStatusBar ? MediaQuery.of(context).viewPadding.top : 0.0;

    return Obx(() {
      final isOffline = !connectionService.isConnected.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status bar spacer - only if considerStatusBar is true
          if (considerStatusBar) SizedBox(height: statusBarHeight),

          // Connection banner with animated height
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isOffline ? 36 : 0,
            width: double.infinity,
            color: bannerColor ?? Colors.red.shade700,
            child:
                isOffline
                    ? Center(
                      // Use Center to align the entire content
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                              0.8, // Limit width
                        ),
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    icon ?? Icons.wifi_off,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: message ?? 'No Internet Connection',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : null,
          ),
        ],
      );
    });
  }
}

/// A wrapper widget that adds a connection banner above its child content.
///
/// This widget simplifies the integration of the connection banner into
/// screens or the overall app structure.
class ConnectionBannerWrapper extends StatelessWidget {
  /// The child widget to display below the connection banner.
  final Widget child;

  /// Whether to consider the status bar height when positioning the banner.
  final bool considerStatusBar;

  /// Optional customization for the banner's appearance.
  final Color? bannerColor;
  final IconData? icon;
  final String? message;

  const ConnectionBannerWrapper({
    super.key,
    required this.child,
    this.considerStatusBar = true,
    this.bannerColor,
    this.icon,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Connection banner
        ConnectionBanner(
          considerStatusBar: considerStatusBar,
          bannerColor: bannerColor,
          icon: icon,
          message: message,
        ),

        // Main content
        Expanded(child: child),
      ],
    );
  }
}
