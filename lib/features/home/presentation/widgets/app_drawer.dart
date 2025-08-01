import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/core/theme/theme_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isAuthenticated = state is Authenticated;
              if (isAuthenticated) {
                final user = (state).user;
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserAvatar(
                          avatarUrl: user.avatarUrl,
                          size: 64,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        if (user.firstName.isNotEmpty ||
                            user.lastName.isNotEmpty)
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const UserAvatar(
                          size: 64,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'Guest',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          // Theme selection
          AppListTile(
            icon: Icons.brightness_6,
            title: 'Dark Mode',
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                context.read<ThemeCubit>().toggleTheme(value);
              },
            ),
          ),
          // Help & Support section
          AppListTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // Auth-dependent action
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return AppListTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AppConfirmationDialog(
                        title: 'Logout',
                        message: 'Are you sure you want to logout?',
                        confirmLabel: 'Logout',
                        confirmColor: theme.colorScheme.error,
                        icon: Icons.logout,
                        iconColor: theme.colorScheme.error,
                        onConfirm: () {
                          context.read<AuthBloc>().add(Logout());
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                    if (shouldLogout == true) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              } else {
                return AppListTile(
                  icon: Icons.login,
                  title: 'Login',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/login');
                  },
                );
              }
            },
          ),
          // App version at the bottom
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingL),
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final info = snapshot.data!;
                return Text(
                  'Version ${info.version} (${info.buildNumber})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
