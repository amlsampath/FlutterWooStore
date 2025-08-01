import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkout_bloc.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import 'payment_method_card.dart';
import 'payment_methods_shimmer.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: context
                      .read<CheckoutBloc>()
                      .repository
                      .getPaymentMethods(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const PaymentMethodsShimmer();
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: ErrorText(
                          text: 'Failed to load payment methods',
                        ),
                      );
                    }

                    final methods = snapshot.data ?? [];

                    if (methods.isEmpty) {
                      return const Center(
                        child: ErrorText(
                          text: 'No payment methods available',
                        ),
                      );
                    }

                    return PaymentMethodCard(
                      paymentMethods: methods,
                      selectedMethodId: state.paymentMethodId,
                      onMethodSelected: (value) {
                        if (value != null) {
                          context
                              .read<CheckoutBloc>()
                              .add(UpdatePaymentMethod(value));
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
