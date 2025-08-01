import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkout_bloc.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme_extension.dart';

class CouponField extends StatefulWidget {
  const CouponField({super.key});

  @override
  State<CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends State<CouponField> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CheckoutBloc>().add(ApplyCoupon(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: appTheme.borderRadiusM,
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: appTheme.paddingM,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coupon Code',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: _controller,
                          label: 'Enter coupon code',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter a coupon code';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingM),
                      AppElevatedButton(
                        text: 'Apply',
                        onPressed: state.isLoading ? null : _applyCoupon,
                        isLoading: state.isLoading,
                        minimumSize:
                            const Size(100, AppDimensions.buttonHeightM),
                      ),
                    ],
                  );
                },
              ),
              if (context.read<CheckoutBloc>().state.couponCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingS),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: AppDimensions.iconSizeM,
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'Coupon ${context.read<CheckoutBloc>().state.couponCode} applied',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
