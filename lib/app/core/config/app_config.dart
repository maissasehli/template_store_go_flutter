import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl {
    final isDevMode = dotenv.env['ENVIRONMENT'] == 'dev';
    return isDevMode
        ? dotenv.env['DEV_BASE_API_URL'] ?? ""
        : dotenv.env['PROD_BASE_API_URL'] ?? "";
  }

  static String get storeId => dotenv.env['STORE_ID'] ?? "";
  static String get publicPusherKey => dotenv.env['PUBLIC_PUSHER_KEY'] ?? "";
  static String get publicPusherCluster =>
      dotenv.env['PUBLIC_PUSHER_CLUSTER'] ?? "";

  // Add Stripe configuration
  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? "";
}
