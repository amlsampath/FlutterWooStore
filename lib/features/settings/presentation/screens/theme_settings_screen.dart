import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_manager.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../widgets/theme_showcase.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.background : AppColors.surface,
      appBar: const AppAppBar(
        title: 'Theme Settings',
      ),
      body: BlocBuilder<ThemeManager, ThemeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSectionHeader(
                    text: 'Appearance',
                    padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
                  ),
                  AppListTile(
                    icon: Icons.light_mode,
                    title: 'Light Mode',
                    subtitle: 'Use light theme for the app',
                    selected: state.themeMode == ThemeMode.light,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.light));
                    },
                  ),
                  const Divider(color: AppColors.divider),
                  AppListTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme for the app',
                    selected: state.themeMode == ThemeMode.dark,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.dark));
                    },
                  ),
                  const Divider(color: AppColors.divider),
                  AppListTile(
                    icon: Icons.settings_system_daydream,
                    title: 'System Default',
                    subtitle: 'Follow system theme settings',
                    selected: state.themeMode == ThemeMode.system,
                    onTap: () {
                      context
                          .read<ThemeManager>()
                          .add(ChangeTheme(ThemeMode.system));
                    },
                  ),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'The app will use the selected theme mode for all screens and components. Changes are applied immediately and saved for future app sessions.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXL),
                  const AppSectionHeader(
                    text: 'Theme Preview',
                    padding: EdgeInsets.only(bottom: AppDimensions.spacingS),
                  ),
                  const ThemeShowcase(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
