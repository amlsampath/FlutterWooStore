import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkout_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/data/models/user_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/snackbar_utils.dart';
import 'payment_method_card.dart';

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CheckoutBloc>();
    if (bloc.state.paymentMethods.isEmpty) {
      bloc.add(LoadPaymentMethods());
    }
  }

  Widget _buildPaymentShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
            4,
            (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),
      ),
    );
  }

  void _placeOrder() {
    final bloc = context.read<CheckoutBloc>();
    final state = bloc.state;
    if (state.isLoading) {
      SnackbarUtils.showInfo(
        context,
        'Payment methods are still loading. Please wait before placing your order.',
      );
      return;
    }
    if (_selectedPaymentMethod == null) return;
    if (state.shippingMethodId == null) {
      SnackbarUtils.showError(
        context,
        'Please select a shipping method first',
      );
      return;
    }
    if (state.billingInfo == null) {
      SnackbarUtils.showError(
        context,
        'Please provide billing information',
      );
      return;
    }
    final paymentMethodId = _selectedPaymentMethod! == 'payhere'
        ? 'payhere_payment'
        : _selectedPaymentMethod!;
    UserModel? currentUser;
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      currentUser = authState.user as UserModel;
    }
    bloc
      ..add(UpdatePaymentMethod(paymentMethodId))
      ..add(PlaceOrder(currentUser: currentUser));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildPaymentShimmer();
        }
        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ErrorText(
                  text: state.error!,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                AppElevatedButton(
                  text: 'Retry',
                  onPressed: () {
                    context.read<CheckoutBloc>().add(LoadPaymentMethods());
                  },
                  minimumSize: const Size(120, AppDimensions.buttonHeightM),
                ),
              ],
            ),
          );
        }
        if (state.paymentMethods.isEmpty) {
          return const Center(
            child: ErrorText(
              text: 'No payment methods available',
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacingM),
            PaymentMethodCard(
              paymentMethods: state.paymentMethods,
              selectedMethodId: _selectedPaymentMethod,
              onMethodSelected: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: AppDimensions.spacingL),
            AppElevatedButton(
              text: 'Place Order',
              onPressed: _selectedPaymentMethod != null ? _placeOrder : null,
              icon: Icons.check_circle,
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
            ),
          ],
        );
      },
    );
  }

  IconData _getPaymentMethodIcon(String methodId) {
    switch (methodId) {
      case 'bacs':
        return Icons.account_balance;
      case 'cod':
        return Icons.money;
      case 'payhere':
      case 'payhere_payment':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}
