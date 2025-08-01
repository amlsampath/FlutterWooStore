import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_extension.dart';
import '../constants/currency_constants.dart';

class CurrencyFormatter {
  static String _cachedCurrency = CurrencyConstants.currencyCode;
  static bool _isCurrencyInitialized = true;

  /// Initialize the currency formatter by loading currency from settings
  static Future<void> initialize() async {
    try {
      final settingsService = GetIt.instance<SettingsService>();
      final currency = await settingsService.getCurrentCurrency();
      _cachedCurrency = currency;
      _isCurrencyInitialized = true;
      print('Currency initialized: $_cachedCurrency'); // Debug log
    } catch (e) {
      print('Error initializing currency formatter: $e');
      // Use default currency if there's an error
      _cachedCurrency = CurrencyConstants.currencyCode;
      _isCurrencyInitialized = true;
    }
  }

  /// Format price with the appropriate currency symbol
  static String formatPrice(String price) {
    double value =
        double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    return CurrencyConstants.currencySymbol + value.toStringAsFixed(2);
  }

  /// Format price with the appropriate currency symbol and return a styled text widget
  static Widget formatPriceText(
    String price, {
    double? fontSize,
    FontWeight? fontWeight,
    BuildContext? context,
  }) {
    final style = context != null
        ? Theme.of(context).appThemeExtension.priceTextStyle.copyWith(
              fontSize: fontSize,
              fontWeight: fontWeight,
            )
        : TextStyle(
            color: AppColors.price,
            fontSize: fontSize ?? 16.0,
            fontWeight: fontWeight ?? FontWeight.bold,
          );

    return Text(
      formatPrice(price),
      style: style,
    );
  }

  /// Creates a styled price text widget with proper theme styling
  /// This is a convenience method for product cards and other places
  /// that need to display a price with the dark theme style
  static Widget styledPriceText(
    BuildContext context,
    String price, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return Text(
      formatPrice(price),
      style: Theme.of(context).appThemeExtension.priceTextStyle.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
    );
  }

  /// Get the appropriate currency symbol based on currency code
  static String _getSymbol() {
    return CurrencyConstants.currencySymbol;
  }

  /// Get the current currency code
  static String getCurrencyCode() {
    return CurrencyConstants.currencyCode;
  }
}
