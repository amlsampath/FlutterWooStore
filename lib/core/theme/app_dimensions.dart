import 'package:flutter/material.dart';

/// App dimensions
/// This class contains all the dimensions used in the app
class AppDimensions {
  // Spacing
  static const double spacingXXS = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;

  // Common padding patterns
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: spacingL,
    vertical: spacingM,
  );

  static const EdgeInsets contentPadding = EdgeInsets.all(spacingM);

  static const EdgeInsets cardPadding = EdgeInsets.all(spacingM);

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spacingL,
    vertical: spacingS,
  );

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );

  static const EdgeInsets dialogPadding = EdgeInsets.all(spacingL);

  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: spacingL,
    vertical: spacingM,
  );

  // Border radius
  static const double borderRadiusXS = 4.0;
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;
  static const double borderRadiusXXL = 32.0;
  static const double borderRadiusCircular = 1000.0;

  // Border width
  static const double borderWidthThin = 1.0;
  static const double borderWidthRegular = 2.0;
  static const double borderWidthThick = 4.0;

  // Icon sizes
  static const double iconSizeXS = 12.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  static const double iconSizeXXL = 64.0;

  // Button sizes
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;

  // Input field sizes
  static const double inputHeightS = 32.0;
  static const double inputHeightM = 40.0;
  static const double inputHeightL = 48.0;
  static const double inputHeightXL = 56.0;

  // Card sizes
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 8.0;

  // Appbar height
  static const double appBarHeight = 56.0;

  // Bottom navigation bar height
  static const double bottomNavBarHeight = 56.0;

  // Tab bar height
  static const double tabBarHeight = 48.0;

  // Drawer width
  static const double drawerWidth = 304.0;

  // Modal bottom sheet
  static const double modalBottomSheetInitialHeight = 300.0;
  static const double modalBottomSheetMinHeight = 200.0;
  static const double modalBottomSheetMaxHeight = 600.0;

  // Product card dimensions
  static const double productCardImageAspectRatio = 1.0;
  static const double textHeightTitle = 16.0;
  static const double textHeightPrice = 24.0;
  static const double priceWidth = 80.0;
  static const double borderRadiusNone = 0.0;
}
