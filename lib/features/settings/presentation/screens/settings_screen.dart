import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_manager.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../features/cart/presentation/widgets/cart_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.background : AppColors.surface,
      appBar: const AppAppBar(
        title: 'Settings',
        actions: [
          CartButton(),
          SizedBox(width: AppDimensions.spacingS),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
        children: [
          // Appearance Section
          const AppSectionHeader(
            text: 'Appearance',
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
          ),
          AppListTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Set app theme (light, dark, system)',
            onTap: () => _showThemeOptions(context),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // Account Section
          const AppSectionHeader(
            text: 'Account',
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
          ),
          AppListTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Manage your personal details',
            onTap: () => context.push('/personal-info'),
          ),
          AppListTile(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            subtitle: 'Manage your shipping addresses',
            onTap: () => context.push('/addresses'),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // Notifications Section
          const AppSectionHeader(
            text: 'Notifications',
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
          ),
          AppListTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Preferences',
            subtitle: 'Control what notifications you receive',
            onTap: () => context.push('/notification-preferences'),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // About Section
          const AppSectionHeader(
            text: 'About',
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
          ),
          const AppListTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
          ),
          AppListTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read our terms of service',
            onTap: () => context.push('/terms'),
          ),
          AppListTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => context.push('/privacy'),
          ),
        ],
      ),
    );
  }

  void _showThemeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ThemeManager, ThemeState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Theme',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  AppListTile(
                    icon: Icons.wb_sunny_outlined,
                    title: 'Light',
                    trailing: state.themeMode == ThemeMode.light
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.light));
                      Navigator.pop(context);
                    },
                  ),
                  AppListTile(
                    icon: Icons.nights_stay_outlined,
                    title: 'Dark',
                    trailing: state.themeMode == ThemeMode.dark
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.dark));
                      Navigator.pop(context);
                    },
                  ),
                  AppListTile(
                    icon: Icons.settings_outlined,
                    title: 'System',
                    trailing: state.themeMode == ThemeMode.system
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.system));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
