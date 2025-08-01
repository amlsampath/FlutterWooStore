import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';
import 'package:ecommerce_app/core/utils/currency_formatter.dart';
import 'package:ecommerce_app/core/widgets/app_primary_button.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_error_message.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_empty_message.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/utils/snackbar_utils.dart';
import 'package:ecommerce_app/core/widgets/app_loading_indicator.dart';
import 'package:ecommerce_app/core/widgets/app_cart_item_row.dart';
import 'package:ecommerce_app/core/widgets/app_confirmation_dialog.dart';
import 'package:ecommerce_app/core/widgets/bottom_navigation.dart';
import 'package:ecommerce_app/core/widgets/custom_radio.dart';
import 'package:ecommerce_app/core/widgets/app_header.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isApplyingPromo = false;
  final bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    // Load cart items when screen initializes
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _proceedToCheckout() async {
    final authLocalDataSource = context.read<AuthLocalDataSource>();
    final user = await authLocalDataSource.getUser();

    if (user != null) {
      // User is logged in, proceed to checkout
      context.push('/checkout');
    } else {
      // User is not logged in, show a message and navigate to login
      SnackbarUtils.showInfo(context, 'Please log in to proceed with checkout');
      // Navigate to login page
      context.push('/login');
    }
  }

  void _showRemoveConfirmationDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog.removeCartItem(
        item: item,
        onConfirm: () {
          context.read<CartBloc>().add(RemoveCartItem(item.productId));

          // Show success message
          SnackbarUtils.showSuccess(
            context,
            '${item.name} removed from cart',
          );

          // Show undo option in a separate snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Item removed'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  context.read<CartBloc>().add(AddCartItem(item));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _applyPromoCode() {
    if (_promoCodeController.text.isEmpty) {
      SnackbarUtils.showError(context, 'Please enter a promo code');
      return;
    }

    setState(() {
      _isApplyingPromo = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isApplyingPromo = false;
      });

      // For demo purposes, accept any code as valid
      SnackbarUtils.showSuccess(
        context,
        'Promo code ${_promoCodeController.text} applied successfully!',
      );

      // In a real app, you would dispatch an event to apply the discount
      // Example: context.read<CartBloc>().add(ApplyPromoCode(_promoCodeController.text));
      _promoCodeController.clear();
    });
  }

  void _toggleSelectAll(bool? value, List<CartItem> items) {
    context.read<CartBloc>().add(ToggleSelectAll(value ?? false));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      // appBar: const AppAppBar(
      //   title: 'My cart',
      //   actions: [
      //     CartIconButton(),
      //   ],
      // ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const AppLoadingIndicator();
          }

          if (state is CartError) {
            return CartErrorMessage(
              message: state.message,
              onRetry: () {
                context.read<CartBloc>().add(LoadCart());
              },
            );
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return CartEmptyMessage(
                onStartShopping: () => context.push('/products'),
              );
            }

            return Column(
              children: [
                const AppHeader(
                  title: 'My cart',
                ),
                // Select all row
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: theme.scaffoldBackgroundColor,
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.selectedProductIds.length ==
                                state.items.length &&
                            state.items.isNotEmpty,
                        onChanged: (value) =>
                            _toggleSelectAll(value, state.items),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        activeColor: AppColors.primary,
                        tristate: false,
                      ),
                      const SizedBox(width: 8),
                      Text('Select all', style: theme.textTheme.bodyLarge),
                      const Spacer(),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: AppColors.error),
                        tooltip: 'Remove selected',
                        onPressed: state.selectedProductIds.isNotEmpty
                            ? () => context
                                .read<CartBloc>()
                                .add(const RemoveSelectedCartItems())
                            : null,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomRadio(
                              selected: state.selectedProductIds
                                  .contains(item.productId),
                              onChanged: (value) => context
                                  .read<CartBloc>()
                                  .add(ToggleCartItemSelection(item.productId)),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: AppCartItemRow(
                              item: item,
                              onDelete: () =>
                                  _showRemoveConfirmationDialog(context, item),
                              imageSize: 64,
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              borderRadius: 16,
                              showQuantityControls: true,
                              showDeleteButton:
                                  false, // Hide delete, use trash icon
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Summary section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(24),
                    //   topRight: Radius.circular(24),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Subtotal:',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(width: 4),
                                Text(
                                  CurrencyFormatter.formatPrice(
                                      state.subtotal.toString()),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        AppColors.textSecondary, // gold/brown
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Delivery fee: Rs. 500.00',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AppPrimaryButton(
                        label: 'Checkout',
                        onPressed: _proceedToCheckout,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const AppLoadingIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
