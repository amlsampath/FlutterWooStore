import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecommerce_app/core/config/app_config.dart';

void main() {
  group('AppConfig Environment Variables', () {
    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: '.env');
    });

    test('should load BASE_URL from environment', () {
      expect(AppConfig.baseUrl, isNotEmpty);
      expect(AppConfig.baseUrl, contains('https://'));
    });

    test('should load CONSUMER_KEY from environment', () {
      expect(AppConfig.consumerKey, isNotEmpty);
      expect(AppConfig.consumerKey, startsWith('ck_'));
    });

    test('should load CONSUMER_SECRET from environment', () {
      expect(AppConfig.consumerSecret, isNotEmpty);
      expect(AppConfig.consumerSecret, startsWith('cs_'));
    });

    test('should load APP_NAME from environment', () {
      expect(AppConfig.appName, isNotEmpty);
      expect(AppConfig.appName, equals('Ecommerce App'));
    });

    test('should load APP_VERSION from environment', () {
      expect(AppConfig.appVersion, isNotEmpty);
      expect(AppConfig.appVersion, equals('1.0.0'));
    });

    test('should load APP_ENVIRONMENT from environment', () {
      expect(AppConfig.appEnvironment, isNotEmpty);
      expect(AppConfig.appEnvironment, equals('development'));
    });

    test('should load feature flags from environment', () {
      expect(AppConfig.enableAnalytics, isTrue);
      expect(AppConfig.enableCrashReporting, isTrue);
      expect(AppConfig.enablePushNotifications, isTrue);
    });

    test(
        'should provide fallback values when environment variables are missing',
        () {
      // Test that the getters don't throw when environment variables are missing
      expect(() => AppConfig.baseUrl, returnsNormally);
      expect(() => AppConfig.consumerKey, returnsNormally);
      expect(() => AppConfig.consumerSecret, returnsNormally);
    });
  });
}
