import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // API Configuration
  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('BASE_URL is required in .env file');
    }
    return url;
  }

  static String get consumerKey {
    final key = dotenv.env['CONSUMER_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('CONSUMER_KEY is required in .env file');
    }
    return key;
  }

  static String get consumerSecret {
    final secret = dotenv.env['CONSUMER_SECRET'];
    if (secret == null || secret.isEmpty) {
      throw Exception('CONSUMER_SECRET is required in .env file');
    }
    return secret;
  }

  // App Configuration
  static String get appName {
    final name = dotenv.env['APP_NAME'];
    if (name == null || name.isEmpty) {
      throw Exception('APP_NAME is required in .env file');
    }
    return name;
  }

  static String get appVersion {
    final version = dotenv.env['APP_VERSION'];
    if (version == null || version.isEmpty) {
      throw Exception('APP_VERSION is required in .env file');
    }
    return version;
  }

  static String get appEnvironment {
    final environment = dotenv.env['APP_ENVIRONMENT'];
    if (environment == null || environment.isEmpty) {
      throw Exception('APP_ENVIRONMENT is required in .env file');
    }
    return environment;
  }

  // Feature Flags
  static bool get enableAnalytics {
    final analytics = dotenv.env['ENABLE_ANALYTICS'];
    if (analytics == null || analytics.isEmpty) {
      throw Exception('ENABLE_ANALYTICS is required in .env file');
    }
    return analytics.toLowerCase() == 'true';
  }

  static bool get enableCrashReporting {
    final crashReporting = dotenv.env['ENABLE_CRASH_REPORTING'];
    if (crashReporting == null || crashReporting.isEmpty) {
      throw Exception('ENABLE_CRASH_REPORTING is required in .env file');
    }
    return crashReporting.toLowerCase() == 'true';
  }

  static bool get enablePushNotifications {
    final pushNotifications = dotenv.env['ENABLE_PUSH_NOTIFICATIONS'];
    if (pushNotifications == null || pushNotifications.isEmpty) {
      throw Exception('ENABLE_PUSH_NOTIFICATIONS is required in .env file');
    }
    return pushNotifications.toLowerCase() == 'true';
  }

  // PayHere Configuration
  static String get payHereMerchantId {
    final merchantId = dotenv.env['PAYHERE_MERCHANT_ID'];
    if (merchantId == null || merchantId.isEmpty) {
      throw Exception('PAYHERE_MERCHANT_ID is required in .env file');
    }
    return merchantId;
  }

  static String get payHereMerchantSecret {
    final merchantSecret = dotenv.env['PAYHERE_MERCHANT_SECRET'];
    if (merchantSecret == null || merchantSecret.isEmpty) {
      throw Exception('PAYHERE_MERCHANT_SECRET is required in .env file');
    }
    return merchantSecret;
  }

  static bool get payHereIsSandbox {
    final isSandbox = dotenv.env['PAYHERE_IS_SANDBOX'];
    if (isSandbox == null || isSandbox.isEmpty) {
      throw Exception('PAYHERE_IS_SANDBOX is required in .env file');
    }
    return isSandbox.toLowerCase() == 'true';
  }

  // Initialize environment variables
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  // Validate all required environment variables
  static void validateEnvironment() {
    // This will throw exceptions if any required values are missing
    baseUrl;
    consumerKey;
    consumerSecret;
    appName;
    appVersion;
    appEnvironment;
    enableAnalytics;
    enableCrashReporting;
    enablePushNotifications;
    payHereMerchantId;
    payHereMerchantSecret;
    payHereIsSandbox;
  }
}
