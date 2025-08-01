import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// App theme extension
/// This class is used to extend the theme with custom properties
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color statusSuccess;
  final Color statusWarning;
  final Color statusError;
  final Color statusInfo;

  final Color shadowColor;
  final List<BoxShadow> elevationShadow1;
  final List<BoxShadow> elevationShadow2;
  final List<BoxShadow> elevationShadow3;

  final BorderRadius borderRadiusXS;
  final BorderRadius borderRadiusS;
  final BorderRadius borderRadiusM;
  final BorderRadius borderRadiusL;
  final BorderRadius borderRadiusXL;
  final BorderRadius borderRadiusCircular;

  final EdgeInsets paddingXS;
  final EdgeInsets paddingS;
  final EdgeInsets paddingM;
  final EdgeInsets paddingL;
  final EdgeInsets paddingXL;

  // Price formatting
  final TextStyle priceTextStyle;

  AppThemeExtension({
    required this.statusSuccess,
    required this.statusWarning,
    required this.statusError,
    required this.statusInfo,
    required this.shadowColor,
    required this.elevationShadow1,
    required this.elevationShadow2,
    required this.elevationShadow3,
    required this.borderRadiusXS,
    required this.borderRadiusS,
    required this.borderRadiusM,
    required this.borderRadiusL,
    required this.borderRadiusXL,
    required this.borderRadiusCircular,
    required this.paddingXS,
    required this.paddingS,
    required this.paddingM,
    required this.paddingL,
    required this.paddingXL,
    required this.priceTextStyle,
  });

  /// Light theme extension
  static AppThemeExtension light = AppThemeExtension(
    statusSuccess: AppColors.success,
    statusWarning: AppColors.warning,
    statusError: AppColors.error,
    statusInfo: AppColors.info,
    shadowColor: Colors.black.withOpacity(0.1),
    elevationShadow1: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
    elevationShadow2: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
    elevationShadow3: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
    borderRadiusXS: BorderRadius.circular(AppDimensions.borderRadiusXS),
    borderRadiusS: BorderRadius.circular(AppDimensions.borderRadiusS),
    borderRadiusM: BorderRadius.circular(AppDimensions.borderRadiusM),
    borderRadiusL: BorderRadius.circular(AppDimensions.borderRadiusL),
    borderRadiusXL: BorderRadius.circular(AppDimensions.borderRadiusXL),
    borderRadiusCircular:
        BorderRadius.circular(AppDimensions.borderRadiusCircular),
    paddingXS: const EdgeInsets.all(AppDimensions.spacingXS),
    paddingS: const EdgeInsets.all(AppDimensions.spacingS),
    paddingM: const EdgeInsets.all(AppDimensions.spacingM),
    paddingL: const EdgeInsets.all(AppDimensions.spacingL),
    paddingXL: const EdgeInsets.all(AppDimensions.spacingXL),
    priceTextStyle: const TextStyle(
      // color: Colors.deepPurple,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  /// Dark theme extension
  static AppThemeExtension dark = AppThemeExtension(
    statusSuccess: AppColors.success,
    statusWarning: AppColors.warning,
    statusError: const Color(0xFFCF6679), // Dark mode variant
    statusInfo: AppColors.info,

    shadowColor: Colors.black.withOpacity(0.2),
    elevationShadow1: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
    elevationShadow2: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
    elevationShadow3: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],

    borderRadiusXS: BorderRadius.circular(AppDimensions.borderRadiusXS),
    borderRadiusS: BorderRadius.circular(AppDimensions.borderRadiusS),
    borderRadiusM: BorderRadius.circular(AppDimensions.borderRadiusM),
    borderRadiusL: BorderRadius.circular(AppDimensions.borderRadiusL),
    borderRadiusXL: BorderRadius.circular(AppDimensions.borderRadiusXL),
    borderRadiusCircular:
        BorderRadius.circular(AppDimensions.borderRadiusCircular),

    paddingXS: const EdgeInsets.all(AppDimensions.spacingXS),
    paddingS: const EdgeInsets.all(AppDimensions.spacingS),
    paddingM: const EdgeInsets.all(AppDimensions.spacingM),
    paddingL: const EdgeInsets.all(AppDimensions.spacingL),
    paddingXL: const EdgeInsets.all(AppDimensions.spacingXL),

    priceTextStyle: const TextStyle(
      color: AppColors.price,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? statusSuccess,
    Color? statusWarning,
    Color? statusError,
    Color? statusInfo,
    Color? shadowColor,
    List<BoxShadow>? elevationShadow1,
    List<BoxShadow>? elevationShadow2,
    List<BoxShadow>? elevationShadow3,
    BorderRadius? borderRadiusXS,
    BorderRadius? borderRadiusS,
    BorderRadius? borderRadiusM,
    BorderRadius? borderRadiusL,
    BorderRadius? borderRadiusXL,
    BorderRadius? borderRadiusCircular,
    EdgeInsets? paddingXS,
    EdgeInsets? paddingS,
    EdgeInsets? paddingM,
    EdgeInsets? paddingL,
    EdgeInsets? paddingXL,
    TextStyle? priceTextStyle,
  }) {
    return AppThemeExtension(
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusWarning: statusWarning ?? this.statusWarning,
      statusError: statusError ?? this.statusError,
      statusInfo: statusInfo ?? this.statusInfo,
      shadowColor: shadowColor ?? this.shadowColor,
      elevationShadow1: elevationShadow1 ?? this.elevationShadow1,
      elevationShadow2: elevationShadow2 ?? this.elevationShadow2,
      elevationShadow3: elevationShadow3 ?? this.elevationShadow3,
      borderRadiusXS: borderRadiusXS ?? this.borderRadiusXS,
      borderRadiusS: borderRadiusS ?? this.borderRadiusS,
      borderRadiusM: borderRadiusM ?? this.borderRadiusM,
      borderRadiusL: borderRadiusL ?? this.borderRadiusL,
      borderRadiusXL: borderRadiusXL ?? this.borderRadiusXL,
      borderRadiusCircular: borderRadiusCircular ?? this.borderRadiusCircular,
      paddingXS: paddingXS ?? this.paddingXS,
      paddingS: paddingS ?? this.paddingS,
      paddingM: paddingM ?? this.paddingM,
      paddingL: paddingL ?? this.paddingL,
      paddingXL: paddingXL ?? this.paddingXL,
      priceTextStyle: priceTextStyle ?? this.priceTextStyle,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      elevationShadow1: t < 0.5 ? elevationShadow1 : other.elevationShadow1,
      elevationShadow2: t < 0.5 ? elevationShadow2 : other.elevationShadow2,
      elevationShadow3: t < 0.5 ? elevationShadow3 : other.elevationShadow3,
      borderRadiusXS:
          BorderRadius.lerp(borderRadiusXS, other.borderRadiusXS, t)!,
      borderRadiusS: BorderRadius.lerp(borderRadiusS, other.borderRadiusS, t)!,
      borderRadiusM: BorderRadius.lerp(borderRadiusM, other.borderRadiusM, t)!,
      borderRadiusL: BorderRadius.lerp(borderRadiusL, other.borderRadiusL, t)!,
      borderRadiusXL:
          BorderRadius.lerp(borderRadiusXL, other.borderRadiusXL, t)!,
      borderRadiusCircular: BorderRadius.lerp(
          borderRadiusCircular, other.borderRadiusCircular, t)!,
      paddingXS: EdgeInsets.lerp(paddingXS, other.paddingXS, t)!,
      paddingS: EdgeInsets.lerp(paddingS, other.paddingS, t)!,
      paddingM: EdgeInsets.lerp(paddingM, other.paddingM, t)!,
      paddingL: EdgeInsets.lerp(paddingL, other.paddingL, t)!,
      paddingXL: EdgeInsets.lerp(paddingXL, other.paddingXL, t)!,
      priceTextStyle: TextStyle.lerp(priceTextStyle, other.priceTextStyle, t)!,
    );
  }
}

/// Extension to access theme extension easily
extension AppThemeExtensionX on ThemeData {
  AppThemeExtension get appThemeExtension => extension<AppThemeExtension>()!;
}
