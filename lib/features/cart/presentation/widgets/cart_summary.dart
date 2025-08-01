import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_summary_card.dart';
import '../bloc/cart_bloc.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          return AppSummaryCard(
            title: 'Total',
            total: CurrencyFormatter.formatPrice(state.total.toString()),
            buttonText: 'Proceed to Checkout',
            onButtonPressed: () => context.push('/checkout'),
            buttonIcon: Icons.shopping_cart_checkout,
            isDark: isDark,
          );
        }
        return const SizedBox();
      },
    );
  }
}
