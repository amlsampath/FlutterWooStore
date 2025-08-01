import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.size = 32,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      radius: size / 2,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null
          ? Icon(
              Icons.person,
              size: size * 0.625,
              color: iconColor ?? theme.colorScheme.primary,
            )
          : null,
    );
  }
}
