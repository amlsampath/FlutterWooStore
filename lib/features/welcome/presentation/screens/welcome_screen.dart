import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/app_outlined_button.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    try {
      final settingsService = GetIt.instance<SettingsService>();
      await settingsService.initializeSettings();
      await CurrencyFormatter.initialize();
      await settingsService.setAppLaunched();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing settings: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load settings. Please check your connection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const AppLoadingIndicator()
          : _errorMessage.isNotEmpty
              ? _buildErrorView()
              : _buildWelcomeView(),
    );
  }

  Widget _buildErrorView() {
    return AppErrorState(
      message: _errorMessage,
      onRetry: () {
        setState(() {
          _isLoading = true;
          _errorMessage = '';
        });
        _initializeSettings();
      },
    );
  }

  Widget _buildWelcomeView() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration or Placeholder Image
              SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/images/welcome.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.emoji_people,
                    size: AppDimensions.iconSizeXXL,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              Text(
                'Welcome to the app',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                "We're excited to help you book and manage your service appointments with ease.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              AppElevatedButton(
                text: 'Login',
                onPressed: () => context.go('/login'),
                minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
                borderRadius: AppDimensions.borderRadiusXL,
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              AppOutlinedButton(
                text: 'Continue as Guest',
                onPressed: () {
                  context.read<AuthBloc>().add(SetGuestUser());
                  context.go('/home');
                },
                minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
                borderRadius: AppDimensions.borderRadiusXL,
                foregroundColor: AppColors.primary,
                borderWidth: 1,
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              AppTextButton(
                text: 'Create an account',
                onPressed: () => context.push('/register'),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
