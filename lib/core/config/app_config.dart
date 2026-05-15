import '../enum/flavor_enum.dart';

class AppConfig {
  AppConfig._();

  static late final FlavorEnum flavor;
  static late final String baseUrl;

  static Future<void> init({required FlavorEnum appFlavor}) async {
    flavor = appFlavor;
    baseUrl = _getBaseUrl(appFlavor);
  }

  static String _getBaseUrl(FlavorEnum flavor) {
    switch (flavor) {
      case FlavorEnum.dev:
        return 'http://127.0.0.1:5000/api/';

      case FlavorEnum.staging:
        return 'https://staging-api.example.com';

      case FlavorEnum.production:
        return 'https://api.example.com';
    }
  }

  static bool get isDev => flavor == FlavorEnum.dev;
  static bool get isStaging => flavor == FlavorEnum.staging;
  static bool get isProduction => flavor == FlavorEnum.production;
}
