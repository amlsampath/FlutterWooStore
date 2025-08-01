import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/snackbar_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            Register(
              username: _emailController.text, // treat as username/email/phone
              email: _emailController.text,
              password: _passwordController.text,
              firstName: _nameController.text,
              lastName: '',
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
          // Top dark background with pattern
          Container(
            height: size.height * 0.6,
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
                Text(
                  'EcoMart',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pacifico',
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Sign up',
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
                  borderRadius: BorderRadius.all(Radius.circular(28)),
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
                      Navigator.pop(context);
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
                            controller: _nameController,
                            label: 'Name',
                            hint: 'Enter your name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
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
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            fillColor: const Color(0xFFF7F7F7),
                            borderRadius: 8,
                            hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD), fontSize: 15),
                            showLabelAboveField: true,
                          ),
                          const SizedBox(height: 28),
                          AppElevatedButton(
                            text: 'Sign up',
                            onPressed: _handleRegister,
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
                          AppTextButton(
                            text: 'Already have an account? Login',
                            onPressed: () => Navigator.of(context).pop(),
                            textStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFB9802A),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextButton(
                            text: 'Go Home',
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed('/home'),
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
