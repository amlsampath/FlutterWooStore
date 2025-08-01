import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;

  const AppLoadingIndicator({
    Key? key,
    this.color,
    this.size,
    this.strokeWidth,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
            strokeWidth: strokeWidth ?? 4.0,
          ),
        ),
      ),
    );
  }
}
