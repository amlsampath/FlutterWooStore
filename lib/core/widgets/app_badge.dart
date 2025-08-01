import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool showZero;

  const AppBadge({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
    this.fontSize,
    this.padding,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!showZero && count <= 0) {
      return const SizedBox.shrink();
    }
    final double badgeSize = size ?? 20.0;
    return Container(
      width: badgeSize,
      height: badgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.error,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: textColor ?? theme.colorScheme.onError,
          fontSize: fontSize ?? 12.0,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
