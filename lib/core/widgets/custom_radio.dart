import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomRadio extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color? activeColor;
  final Color borderColor;
  final Color? backgroundColor;

  const CustomRadio({
    super.key,
    required this.selected,
    required this.onChanged,
    this.size = 20,
    this.activeColor,
    this.borderColor = const Color(0xFFD1D1D1),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveActiveColor = activeColor ?? AppColors.primary;
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? effectiveActiveColor : borderColor,
            width: 2,
          ),
          color: backgroundColor ?? Colors.white,
        ),
        child: selected
            ? Center(
                child: Container(
                  width: size / 2,
                  height: size / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: effectiveActiveColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
