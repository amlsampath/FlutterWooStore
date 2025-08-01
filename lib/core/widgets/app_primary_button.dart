import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final Color? color;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;
  final double? width;

  const AppPrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.borderRadius = AppDimensions.borderRadiusM,
    this.height = AppDimensions.buttonHeightL,
    this.textStyle,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(width ?? 0, height),
          padding: AppDimensions.buttonPadding,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: AppDimensions.iconSizeL,
                  height: AppDimensions.iconSizeL,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppDimensions.spacingS),
                  ],
                  Text(
                    label,
                    style: textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.textHeightTitle,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
