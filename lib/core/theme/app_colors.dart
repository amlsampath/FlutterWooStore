import 'package:flutter/material.dart';

/// App color palette
/// This class contains all the colors used in the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF222831);
  static const Color secondary = Color(0xFF917246);
  // static const Color primaryLight = Color(0xFF03DAC6);
  // static const Color primaryDark = Color(0xFF3700B3);

  // static const Color secondaryLight = Color(0xFF66FFF8);
  // static const Color secondaryDark = Color(0xFF018786);

  // Surface Colors
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color scaffoldBackground = Color(0xFFF8F8F8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color dialogBackground = Color(0xFF1E1E1E);
  static const Color bottomSheetBackground = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF262323);
  static const Color textSecondary = Color(0xFF917246);
  // static const Color textHint = Color(0xFF9E9E9E);
  // static const Color textDisabled = Color(0xFF757575);
  // static const Color textError = Color(0xFFCF6679);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF80E27E);
  static const Color successDark = Color(0xFF087F23);
  static const Color error = Color(0xFFCF6679);
  static const Color errorLight = Color(0xFFFF8A80);
  static const Color errorDark = Color(0xFFB00020);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Border & Divider Colors
  static const Color border = Color(0xFF333333);
  static const Color borderLight = Color(0xFF424242);
  static const Color borderDark = Color(0xFF212121);
  static const Color divider = Color(0xFF353535);
  static const Color dividerLight = Color(0xFF424242);
  static const Color dividerDark = Color(0xFF212121);

  // Icon Colors
  static const Color iconPrimary = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xFFB3B3B3);
  static const Color iconDisabled = Color(0xFF757575);
  static const Color iconError = Color(0xFFCF6679);
  static const Color iconSuccess = Color(0xFF4CAF50);

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryDisabled = Color(0xFF757575);
  static const Color buttonSecondary = secondary;
  static const Color buttonSecondaryDisabled = Color(0xFF757575);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonTextDisabled = Color(0xFFB3B3B3);

  // Input Field Colors
  static const Color inputBackground = Color(0xFF1E1E1E);
  static const Color inputBorderFocused = primary;
  static const Color inputBorderError = error;
  static const Color inputText = Color(0xFFFFFFFF);
  static const Color inputHint = Color(0xFF9E9E9E);
  static const Color inputDisabled = Color(0xFF757575);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color modalBarrier = Color(0x80000000);
  static const Color scrim = Color(0x80000000);

  // Shadow Colors
  static const Color shadow = Color(0x3F000000);
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x5F000000);

  // Price Colors
  static const Color price = Color(0xFF9C27B0);
  static const Color priceLight = Color(0xFFBA68C8);
  static const Color priceDark = Color(0xFF7B1FA2);

  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
  static const Color twitter = Color(0xFF1DA1F2);

  // Chart Colors
  static const Color chart1 = Color(0xFF2196F3);
  static const Color chart2 = Color(0xFF4CAF50);
  static const Color chart3 = Color(0xFFFFC107);
  static const Color chart4 = Color(0xFFF44336);
  static const Color chart5 = Color(0xFF9C27B0);

  // Card Colors
  static const Color imageBackground = Color(0xFFF5F5F5);
  static const Color counterBackground = Color(0xFFF5F5F5);
  static const Color counterBorder = Color(0xFFE0E0E0);
  static const Color counterButton = Color(0xFFB08B53);
}

// import 'package:flutter/material.dart';

// /// App color palette
// /// This class contains all the colors used in the app
// class AppColors {
//   // Private constructor to prevent instantiation
//   AppColors._();

//   // Brand Colors
//   static const Color primary = Color(0xFF018786);
//   static const Color primaryLight = Color(0xFF03DAC6);
//   static const Color primaryDark = Color(0xFF3700B3);
//   static const Color secondary = Color(0xFF03DAC6);
//   static const Color secondaryLight = Color(0xFF66FFF8);
//   static const Color secondaryDark = Color(0xFF018786);

//   // Surface Colors
//   static const Color background = Color(0xFF121212);
//   static const Color surface = Color(0xFF1E1E1E);
//   static const Color scaffoldBackground = Color(0xFF121212);
//   static const Color cardBackground = Color(0xFF1E1E1E);
//   static const Color dialogBackground = Color(0xFF1E1E1E);
//   static const Color bottomSheetBackground = Color(0xFF1E1E1E);

//   // Text Colors
//   static const Color textPrimary = Color(0xFFFFFFFF);
//   static const Color textSecondary = Color(0xFFB3B3B3);
//   static const Color textHint = Color(0xFF9E9E9E);
//   static const Color textDisabled = Color(0xFF757575);
//   static const Color textError = Color(0xFFCF6679);

//   // Status Colors
//   static const Color success = Color(0xFF4CAF50);
//   static const Color successLight = Color(0xFF80E27E);
//   static const Color successDark = Color(0xFF087F23);
//   static const Color error = Color(0xFFCF6679);
//   static const Color errorLight = Color(0xFFFF8A80);
//   static const Color errorDark = Color(0xFFB00020);
//   static const Color warning = Color(0xFFFF9800);
//   static const Color warningLight = Color(0xFFFFB74D);
//   static const Color warningDark = Color(0xFFF57C00);
//   static const Color info = Color(0xFF2196F3);
//   static const Color infoLight = Color(0xFF64B5F6);
//   static const Color infoDark = Color(0xFF1976D2);

//   // Border & Divider Colors
//   static const Color border = Color(0xFF333333);
//   static const Color borderLight = Color(0xFF424242);
//   static const Color borderDark = Color(0xFF212121);
//   static const Color divider = Color(0xFF353535);
//   static const Color dividerLight = Color(0xFF424242);
//   static const Color dividerDark = Color(0xFF212121);

//   // Icon Colors
//   static const Color iconPrimary = Color(0xFFFFFFFF);
//   static const Color iconSecondary = Color(0xFFB3B3B3);
//   static const Color iconDisabled = Color(0xFF757575);
//   static const Color iconError = Color(0xFFCF6679);
//   static const Color iconSuccess = Color(0xFF4CAF50);

//   // Button Colors
//   static const Color buttonPrimary = primary;
//   static const Color buttonPrimaryDisabled = Color(0xFF757575);
//   static const Color buttonSecondary = secondary;
//   static const Color buttonSecondaryDisabled = Color(0xFF757575);
//   static const Color buttonText = Color(0xFFFFFFFF);
//   static const Color buttonTextDisabled = Color(0xFFB3B3B3);

//   // Input Field Colors
//   static const Color inputBackground = Color(0xFF1E1E1E);
//   static const Color inputBorder = Color(0xFF333333);
//   static const Color inputBorderFocused = primary;
//   static const Color inputBorderError = error;
//   static const Color inputText = Color(0xFFFFFFFF);
//   static const Color inputHint = Color(0xFF9E9E9E);
//   static const Color inputDisabled = Color(0xFF757575);

//   // Overlay Colors
//   static const Color overlay = Color(0x80000000);
//   static const Color modalBarrier = Color(0x80000000);
//   static const Color scrim = Color(0x80000000);

//   // Shadow Colors
//   static const Color shadow = Color(0x3F000000);
//   static const Color shadowLight = Color(0x1F000000);
//   static const Color shadowDark = Color(0x5F000000);

//   // Price Colors
//   static const Color price = Color(0xFF9C27B0);
//   static const Color priceLight = Color(0xFFBA68C8);
//   static const Color priceDark = Color(0xFF7B1FA2);

//   // Social Media Colors
//   static const Color facebook = Color(0xFF1877F2);
//   static const Color google = Color(0xFFDB4437);
//   static const Color apple = Color(0xFF000000);
//   static const Color twitter = Color(0xFF1DA1F2);

//   // Chart Colors
//   static const Color chart1 = Color(0xFF2196F3);
//   static const Color chart2 = Color(0xFF4CAF50);
//   static const Color chart3 = Color(0xFFFFC107);
//   static const Color chart4 = Color(0xFFF44336);
//   static const Color chart5 = Color(0xFF9C27B0);
// }
