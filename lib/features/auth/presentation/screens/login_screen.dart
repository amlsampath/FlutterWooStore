import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/utils/snackbar_utils.dart';
import 'package:flutter/gestures.dart';
import '../../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final bool _keepSignedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            Login(
              username: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Top dark background with pattern (replace with your asset if needed)
          Container(
            height: size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF23262F),
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 56),
                // Logo (replace with your asset if needed)
                Text(
                  'EcoMart',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pacifico', // Use your logo font if available
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Login',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back to EcoMart Shop!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // White card with form
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: size.height * 0.32),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.10),
                  //     blurRadius: 48,
                  //     spreadRadius: 12,
                  //     offset: const Offset(0, 12),
                  //   ),
                  // ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 44,
                ),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      context.go('/home');
                    } else if (state is AuthError) {
                      SnackbarUtils.showError(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextFormField(
                            controller: _emailController,
                            label: 'Email/ Phone number',
                            hint: 'Enter your email or phone number',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email or phone number';
                              }
                              final emailRegex =
                                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              final phoneRegex = RegExp(r'^\d{10,}$');
                              if (!emailRegex.hasMatch(value) &&
                                  !phoneRegex.hasMatch(value)) {
                                return 'Please enter a valid email or phone number';
                              }
                              return null;
                            },
                            fillColor: const Color(0xFFF7F7F7),
                            borderRadius: 8,
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 15),
                            showLabelAboveField: true,
                          ),
                          const SizedBox(height: 18),
                          AppTextFormField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            fillColor: const Color(0xFFF7F7F7),
                            borderRadius: 8,
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 15),
                            showLabelAboveField: true,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppTextButton(
                                text: 'Forgot password?',
                                onPressed: () =>
                                    context.push('/forgot-password'),
                                textStyle: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFB9802A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          AppElevatedButton(
                            text: 'Login',
                            onPressed: _handleLogin,
                            isLoading: state is AuthLoading,
                            minimumSize: const Size.fromHeight(56),
                            backgroundColor: const Color(0xFF23262F),
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            borderRadius: 16,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          const SizedBox(height: 28),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Are you a new user? ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Create an account',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFFB9802A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.push('/register'),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextButton(
                            text: 'Go Home',
                            onPressed: () => context.go('/home'),
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
