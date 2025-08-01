import 'package:flutter/material.dart';

class ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? iconColor;
  final String? tooltip;

  const ClearAllButton({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(
        Icons.delete_outline,
        color: iconColor ?? theme.colorScheme.onSurface,
      ),
      tooltip: tooltip ?? 'Clear All',
      onPressed: onPressed,
    );
  }
}
