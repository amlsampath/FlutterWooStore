import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class FormFieldRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const FormFieldRow({
    super.key,
    required this.children,
    this.spacing = AppDimensions.spacingS,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}
