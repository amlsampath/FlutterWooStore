import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/payment_methods_shimmer.dart';
import '../widgets/order_submission_shimmer.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/error_list.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/snackbar_utils.dart';

class PaymentScreen extends StatefulWidget {
  final String shippingMethodId;

  const PaymentScreen({
    super.key,
    required this.shippingMethodId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    // Update the shipping method in the CheckoutBloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckoutBloc>()
        ..add(UpdateShippingMethod(widget.shippingMethodId))
        ..add(LoadPaymentMethods());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess && state.orderDetails != null) {
          context.push('/checkout/summary', extra: {
            'orderDetails': state.orderDetails,
            'billingInfo': state.billingInfo,
          });
        } else if (state is PaymentFailed) {
          context.push('/orders/${state.orderId}',
              extra: {'status': state.status});
        } else if (state is CheckoutError) {
          SnackbarUtils.showError(context, state.error ?? 'An error occurred');
        }
      },
      child: Scaffold(
        appBar: const AppAppBar(
          title: 'Payment',
        ),
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: AppDimensions.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show missing fields if any
                    Builder(
                      builder: (context) {
                        final missingFields = getMissingCheckoutFields(state);
                        if (missingFields.isNotEmpty) {
                          return Card(
                            color: theme.cardColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: appTheme.borderRadiusM,
                              side: BorderSide(
                                color: AppColors.error.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: appTheme.paddingM,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ErrorText(
                                    text:
                                        'Please fill in the following information:',
                                  ),
                                  ErrorList(
                                    items: missingFields,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    Text(
                      'Select a payment method',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    if (state.isLoading)
                      state.paymentMethods.isEmpty
                          ? const PaymentMethodsShimmer()
                          : const OrderSubmissionShimmer()
                    else
                      const PaymentMethodSelector(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Utility to get missing checkout fields
  List<String> getMissingCheckoutFields(CheckoutState state) {
    final missing = <String>[];
    final billing = state.billingInfo;
    final shipping = state.shippingInfo;

    if (billing == null ||
        billing.firstName.isEmpty ||
        billing.lastName.isEmpty ||
        billing.email.isEmpty ||
        billing.phone.isEmpty ||
        billing.address.isEmpty ||
        billing.city.isEmpty ||
        billing.state.isEmpty ||
        billing.zip.isEmpty) {
      missing.add('Billing Address');
    }
    if (shipping == null ||
        shipping.firstName.isEmpty ||
        shipping.lastName.isEmpty ||
        shipping.phone.isEmpty ||
        shipping.address.isEmpty ||
        shipping.city.isEmpty ||
        shipping.state.isEmpty ||
        shipping.zip.isEmpty) {
      missing.add('Shipping Address');
    }
    if (state.shippingMethodId == null) {
      missing.add('Shipping Method');
    }
    return missing;
  }
}
