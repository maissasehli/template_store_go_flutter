import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Shows an authentication WebView and returns the redirect URL with tokens
///
/// This function will detect URLs starting with http://localhost:3000
/// and extract the token data from the URL fragment or query parameters.
Future<String?> showAuthWebView(String authUrl) async {
  final logger = Logger();
  final completer = Completer<String?>();
  bool hasCompletedAuth = false;

  logger.i("Opening WebView with URL: $authUrl");

  // Configure global WebView settings once before showing dialog
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);

  await showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign in'),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(authUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                clearCache: true,
                // Use a desktop user agent to avoid mobile-specific issues
                userAgent:
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
                // These are critical for security warnings
                preferredContentMode: UserPreferredContentMode.RECOMMENDED,
                supportZoom: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                safeBrowsingEnabled: false,
                // This is critical for handling security warnings
                mixedContentMode:
                    AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                supportMultipleWindows: true,
                // Disable safe browsing completely
                // Allow insecure connections
                allowContentAccess: true,
                allowFileAccess: true,
                // Disable warnings about insecure content
                blockNetworkLoads: false,
                blockNetworkImage: false,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
                allowsBackForwardNavigationGestures: true,
                // Disable all iOS security warnings
                disableLongPressContextMenuOnLinks: true,
                isFraudulentWebsiteWarningEnabled: false,
                allowsLinkPreview: false,
              ),
            ),
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              // This is critical - automatically accept all SSL certificates
              logger.i(
                "Received server trust request - accepting all certificates",
              );
              return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED,
              );
            },
            onReceivedHttpAuthRequest: (controller, challenge) async {
              logger.i("Received HTTP auth request - proceeding");
              return HttpAuthResponse(action: HttpAuthResponseAction.PROCEED);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              logger.i("URL navigation detected: ${_sanitizeUrl(url)}");

              // Check if this is our localhost redirect with tokens
              if (url.startsWith('http://localhost:3000')) {
                logger.i("⭐ Localhost URL detected! Checking for tokens...");

                // Check for access_token in fragment or query params
                if (url.contains('access_token=')) {
                  logger.i("✅ SUCCESS: Found access_token in redirect URL");
                  hasCompletedAuth = true;

                  // Complete the future and close the dialog
                  if (!completer.isCompleted) {
                    completer.complete(url);
                    Navigator.of(context).pop();
                  }
                  return NavigationActionPolicy.CANCEL;
                }
              }

              // Allow normal navigation for all other URLs
              return NavigationActionPolicy.ALLOW;
            },
            onReceivedError: (controller, request, error) {
              logger.e("WebView error: ${error.description}");
            },
            onLoadStart: (controller, url) {
              if (url != null) {
                final urlString = url.toString();
                logger.i("WebView loading: ${_sanitizeUrl(urlString)}");

                // Check for localhost redirect with tokens
                if (urlString.startsWith('http://localhost:3000') &&
                    !hasCompletedAuth) {
                  if (urlString.contains('access_token=')) {
                    logger.i("✅ Found access_token in onLoadStart");
                    hasCompletedAuth = true;
                    if (!completer.isCompleted) {
                      completer.complete(urlString);
                      Navigator.of(context).pop();
                    }
                  }
                }
              }
            },
            onLoadStop: (controller, url) async {
              if (url != null) {
                final urlString = url.toString();
                logger.i("WebView loaded: ${_sanitizeUrl(urlString)}");

                // Final check for localhost URL with tokens
                if (!hasCompletedAuth &&
                    urlString.startsWith('http://localhost:3000')) {
                  logger.i("Checking loaded localhost URL for tokens");

                  if (urlString.contains('access_token=')) {
                    logger.i("✅ SUCCESS: Found access_token in onLoadStop");
                    hasCompletedAuth = true;
                    if (!completer.isCompleted) {
                      completer.complete(urlString);
                      Navigator.of(context).pop();
                    }
                  } else {
                    // Try to get full URL from JavaScript if tokens aren't visible in the URL
                    try {
                      logger.i(
                        "Trying to extract complete URL using JavaScript",
                      );

                      // First try window.location.href
                      final location = await controller.evaluateJavascript(
                        source: "window.location.href",
                      );
                      logger.i(
                        "JS location: ${_sanitizeUrl(location?.toString() ?? '')}",
                      );

                      if (location != null &&
                          location.toString().contains('access_token=')) {
                        logger.i("✅ SUCCESS: Found tokens via JavaScript href");
                        hasCompletedAuth = true;
                        if (!completer.isCompleted) {
                          completer.complete(location.toString());
                          Navigator.of(context).pop();
                        }
                        return;
                      }

                      // Check for hash fragment separately
                      final hashCheck = await controller.evaluateJavascript(
                        source: "window.location.hash",
                      );
                      logger.i(
                        "Hash part: ${_sanitizeLogString(hashCheck?.toString() ?? '')}",
                      );

                      if (hashCheck != null &&
                          hashCheck.toString().contains('access_token=')) {
                        final fullUrl =
                            "${urlString.split('#')[0]}${hashCheck.toString()}";
                        logger.i("✅ SUCCESS: Found tokens in hash part");
                        hasCompletedAuth = true;
                        if (!completer.isCompleted) {
                          completer.complete(fullUrl);
                          Navigator.of(context).pop();
                        }
                        return;
                      }

                      // Last attempt - try to get document.URL which sometimes has more info
                      final docUrl = await controller.evaluateJavascript(
                        source: "document.URL",
                      );
                      logger.i(
                        "Document URL: ${_sanitizeUrl(docUrl?.toString() ?? '')}",
                      );

                      if (docUrl != null &&
                          docUrl.toString().contains('access_token=')) {
                        logger.i("✅ SUCCESS: Found tokens in document.URL");
                        hasCompletedAuth = true;
                        if (!completer.isCompleted) {
                          completer.complete(docUrl.toString());
                          Navigator.of(context).pop();
                        }
                      }
                    } catch (e) {
                      logger.e("Error extracting URL via JavaScript: $e");
                    }
                  }
                }
              }
            },
            // Handle SSL errors - critical for avoiding security warnings
            onReceivedHttpError: (controller, handler, error) async {
              logger.w(
                "SSL error encountered - proceeding anyway: ${error.data}",
              );
              
              return;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              logger.w("Authentication canceled by user");
              if (!completer.isCompleted) {
                completer.complete(null);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );

  final result = await completer.future;
  return result;
}

// Helper to sanitize URLs for logging (hide full tokens)
String _sanitizeUrl(String url) {
  if (url.contains('access_token=')) {
    // Keep the start of the URL but hide the token values
    final parts = url.split('access_token=');
    if (parts.length > 1) {
      final beforeToken = parts[0];
      final afterToken =
          parts[1].contains('&')
              ? '&' + parts[1].split('&').skip(1).join('&')
              : '';
      return '$beforeToken' + 'access_token=[HIDDEN]' + afterToken;
    }
  }
  return url;
}

// Helper to sanitize long strings for logging
String _sanitizeLogString(String input) {
  if (input.length > 30) {
    return "${input.substring(0, 30)}...";
  }
  return input;
}
