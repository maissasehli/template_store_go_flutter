import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  static String get baseUrl => dotenv.env['BASE_API_ENDPOINT'] ?? "";
  static String get storeId => dotenv.env['STORE_ID'] ?? "";
  static String get publicPusherKey => dotenv.env['PUBLIC_PUSHER_KEY'] ?? "";
  static String get publicPusherCluster =>
      dotenv.env['PUBLIC_PUSHER_CLUSTER'] ?? "";
}
