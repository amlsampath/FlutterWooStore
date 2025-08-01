import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsService {
  final Dio dio;
  final String baseUrl;
  static const String _prefsKeySettings = 'woocommerce_settings';
  static const String _prefsKeyFirstLaunch = 'is_first_launch';

  SettingsService({
    required this.dio,
    required this.baseUrl,
  });

  /// Fetches the general currency settings from WooCommerce API
  Future<Map<String, dynamic>> fetchCurrencySettings() async {
    try {
      final response = await dio.get(
        '$baseUrl/wp-json/wc/v3/settings/general/woocommerce_currency',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load currency settings');
      }
    } catch (e) {
      // Return default settings if API call fails
      return {
        "id": "woocommerce_currency",
        "label": "Currency",
        "description":
            "This controls what currency prices are listed at in the catalog.",
        "type": "select",
        "default": "USD",
        "value": "USD",
      };
    }
  }

  /// Save settings to local storage
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeySettings, jsonEncode(settings));
  }

  /// Get settings from local storage
  Future<Map<String, dynamic>?> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_prefsKeySettings);

    if (settingsJson != null) {
      return jsonDecode(settingsJson);
    }
    return null;
  }

  /// Check if this is the first app launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKeyFirstLaunch) ?? true;
  }

  /// Mark that the app has been launched
  Future<void> setAppLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyFirstLaunch, false);
  }

  /// Get the current currency code
  Future<String> getCurrentCurrency() async {
    final settings = await getSettings();
    if (settings != null && settings.containsKey('value')) {
      return settings['value'];
    }
    return 'USD'; // Default currency
  }

  /// Initialize settings by fetching from API and storing locally
  Future<void> initializeSettings() async {
    final currencySettings = await fetchCurrencySettings();
    await saveSettings(currencySettings);
  }
}
