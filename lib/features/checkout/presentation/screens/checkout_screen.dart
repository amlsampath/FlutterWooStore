import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/checkout_bloc.dart';
import '../../domain/entities/shipping_info.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../domain/entities/billing_info.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/bottom_sheet_utils.dart';
import '../../../../core/widgets/error_state_message.dart';
import '../../../cart/presentation/widgets/cart_empty_message.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../bloc/shipping_address_bloc.dart';
import '../bloc/billing_address_bloc.dart';
import '../widgets/shipping_methods_shimmer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _useShippingAsBilling = false;

  @override
  void initState() {
    super.initState();
    context.read<ShippingAddressBloc>().add(LoadShippingAddress());
    context.read<BillingAddressBloc>().add(LoadBillingAddress());
    context.read<CheckoutBloc>().add(LoadBillingInfo());
    context.read<CheckoutBloc>().add(LoadShippingMethods());
    context.read<CartBloc>().add(LoadCart());
  }

  void _showAddressBottomSheet({ShippingInfo? initialData}) {
    final shippingState = context.read<ShippingAddressBloc>().state;
    ShippingInfo? shippingInfo = initialData;
    if (shippingState is ShippingAddressLoaded) {
      shippingInfo = shippingState.shippingInfo;
    }
    BottomSheetUtils.show(
      context: context,
      child: _AddressForm(
        initialData: shippingInfo,
        onSave: (info) {
          context.read<ShippingAddressBloc>().add(SaveShippingAddress(info));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showBillingAddressBottomSheet({BillingInfo? initialData}) {
    final billingState = context.read<BillingAddressBloc>().state;
    BillingInfo? billingInfo = initialData;
    if (billingState is BillingAddressLoaded) {
      billingInfo = billingState.billingInfo;
    }
    BottomSheetUtils.show(
      context: context,
      child: _BillingAddressForm(
        initialData: billingInfo,
        onSave: (info) {
          context.read<BillingAddressBloc>().add(SaveBillingAddress(info));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const orange = Color(0xFFFF9900);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping address',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      TextButton(
                        onPressed: () => _showAddressBottomSheet(),
                        style: TextButton.styleFrom(
                          foregroundColor: orange,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Change',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
                    builder: (context, state) {
                      if (state is ShippingAddressLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ShippingAddressSuccess) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(state.message,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            isShippingAddressEmpty(state.shippingInfo)
                                ? _buildAddShippingAddressButton(context, theme)
                                : _buildShippingAddressCard(
                                    state.shippingInfo, context),
                          ],
                        );
                      } else if (state is ShippingAddressError) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Text('Error: ${state.message}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else if (state is ShippingAddressLoaded) {
                        return isShippingAddressEmpty(state.shippingInfo)
                            ? _buildAddShippingAddressButton(context, theme)
                            : _buildShippingAddressCard(
                                state.shippingInfo, context);
                      }
                      return _buildAddShippingAddressButton(context, theme);
                    },
                  ),
                  const SizedBox(height: 10),
                  // TODO: Implement useShippingAsBilling logic in state if needed
                  Row(
                    children: [
                      Checkbox(
                        value: _useShippingAsBilling,
                        onChanged: (val) {
                          setState(() {
                            _useShippingAsBilling = val ?? false;
                          });
                          if (_useShippingAsBilling) {
                            context
                                .read<ShippingAddressBloc>()
                                .add(LoadShippingAddress());
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const Text('Please use this as the billing address'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Billing Address Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Billing address',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      TextButton(
                        onPressed: () => _showBillingAddressBottomSheet(),
                        style: TextButton.styleFrom(
                          foregroundColor: orange,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Change',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<BillingAddressBloc, BillingAddressState>(
                    builder: (context, state) {
                      if (state is BillingAddressLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BillingAddressSuccess) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(state.message,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            isBillingAddressEmpty(state.billingInfo)
                                ? _buildAddBillingAddressButton(context, theme)
                                : _buildBillingAddressCard(
                                    state.billingInfo, context),
                          ],
                        );
                      } else if (state is BillingAddressError) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            Text('Error: ${state.message}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else if (state is BillingAddressLoaded) {
                        return isBillingAddressEmpty(state.billingInfo)
                            ? _buildAddBillingAddressButton(context, theme)
                            : _buildBillingAddressCard(
                                state.billingInfo, context);
                      }
                      return _buildAddBillingAddressButton(context, theme);
                    },
                  ),
                  const SizedBox(height: 18),
                  // Shipping Type Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping type',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: orange,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Change',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, checkoutState) {
                      // Show loading if explicitly loading OR if methods are empty and no error
                      final shouldShowLoading =
                          checkoutState is CheckoutLoading ||
                              checkoutState.isLoading ||
                              (checkoutState.shippingMethods.isEmpty &&
                                  checkoutState.error == null);

                      if (shouldShowLoading) {
                        return const ShippingMethodsShimmer();
                      }

                      final error = checkoutState.error;
                      final methods = checkoutState.shippingMethods;

                      if (error != null && methods.isEmpty) {
                        return ErrorStateMessage(
                          message: error,
                          icon: Icons.error_outline,
                          onRetryPressed: () {
                            context
                                .read<CheckoutBloc>()
                                .add(LoadShippingMethods());
                          },
                        );
                      }

                      if (methods.isEmpty) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusM),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(AppDimensions.spacingM),
                            child: Text('No shipping methods available'),
                          ),
                        );
                      }
                      return Column(
                        children: methods.map<Widget>((method) {
                          final methodId = method['id']?.toString();
                          if (methodId == null) return const SizedBox.shrink();
                          final isSelected =
                              checkoutState.shippingMethodId == methodId;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? orange : Colors.transparent,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            color: isSelected
                                ? const Color(0xFFF5F3EF)
                                : Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context
                                    .read<CheckoutBloc>()
                                    .add(UpdateShippingMethod(methodId));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: methodId,
                                      groupValue:
                                          checkoutState.shippingMethodId,
                                      onChanged: (val) {
                                        if (val != null) {
                                          context
                                              .read<CheckoutBloc>()
                                              .add(UpdateShippingMethod(val));
                                        }
                                      },
                                      activeColor: orange,
                                    ),
                                    const Icon(Icons.local_shipping_outlined,
                                        size: 28, color: Colors.grey),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            method['title'] ?? 'Flat rate',
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Estimated arrival in 3-5 days',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (method['cost'] != null)
                                      Text(
                                        CurrencyFormatter.formatPrice(
                                            method['cost']),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  // Order List Section
                  Text('Order list',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      )),
                  const SizedBox(height: 6),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppDimensions.spacingM),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (cartState is CartError) {
                        return ErrorStateMessage(
                          message: 'Failed to load cart items',
                          icon: Icons.error_outline,
                          onRetryPressed: () {
                            context.read<CartBloc>().add(LoadCart());
                          },
                        );
                      }
                      if (cartState is CartLoaded) {
                        final items = cartState.items;
                        if (items.isEmpty) {
                          return CartEmptyMessage(
                            onStartShopping: () => context.push('/products'),
                          );
                        }
                        return Column(
                          children: [
                            ...items.map((item) => Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme
                                                .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: item.imageUrl.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                      item.imageUrl,
                                                      fit: BoxFit.cover),
                                                )
                                              : const Icon(Icons.image,
                                                  size: 32, color: Colors.grey),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: theme.textTheme.bodyLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                CurrencyFormatter.formatPrice(
                                                    item.price),
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: orange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Quantity - ${item.quantity}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color:
                                                            Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 8),
                            // Order Summary
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Column(
                                  children: [
                                    _OrderSummaryRow(
                                      label: 'Sub total',
                                      value: CurrencyFormatter.formatPrice(
                                          cartState.subtotal.toString()),
                                    ),
                                    _OrderSummaryRow(
                                      label: 'Tax',
                                      value: CurrencyFormatter.formatPrice(
                                          cartState.tax.toString()),
                                    ),
                                    _OrderSummaryRow(
                                      label: 'Shipping',
                                      value: CurrencyFormatter.formatPrice(
                                          _getShippingCost().toString()),
                                    ),
                                    _OrderSummaryRow(
                                      label: 'Discount',
                                      value: CurrencyFormatter.formatPrice(
                                          cartState.discount.toString()),
                                    ),
                                    const Divider(),
                                    _OrderSummaryRow(
                                      label: 'Total',
                                      value: CurrencyFormatter.formatPrice(
                                        (cartState.subtotal +
                                                cartState.tax +
                                                _getShippingCost() -
                                                cartState.discount)
                                            .toString(),
                                      ),
                                      isTotal: true,
                                      color: orange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
                builder: (context, shippingState) {
                  String buttonLabel = 'Continue to payment';
                  bool canContinue = false;
                  ShippingInfo? shippingInfo;
                  if (shippingState is ShippingAddressLoaded) {
                    shippingInfo = shippingState.shippingInfo;
                    canContinue = shippingInfo.address.isNotEmpty &&
                        shippingInfo.city.isNotEmpty;
                  } else if (shippingState is ShippingAddressSuccess) {
                    shippingInfo = shippingState.shippingInfo;
                    canContinue = shippingInfo.address.isNotEmpty &&
                        shippingInfo.city.isNotEmpty;
                  }
                  if (!canContinue) {
                    buttonLabel = 'Add Shipping Address';
                  }
                  return BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, checkoutState) {
                      final shippingMethodId = checkoutState.shippingMethodId;
                      final readyToContinue =
                          canContinue && shippingMethodId != null;
                      String finalLabel = buttonLabel;
                      if (canContinue && shippingMethodId == null) {
                        finalLabel = 'Select Shipping Method';
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeightL,
                        child: AppPrimaryButton(
                          label: finalLabel,
                          onPressed: readyToContinue
                              ? () {
                                  // _placeOrder(context);
                                  context.push('/checkout/payment', extra: {
                                    'shippingMethodId': shippingMethodId
                                  });
                                }
                              : () {
                                  if (!canContinue) {
                                    _showAddressBottomSheet();
                                    SnackbarUtils.showError(
                                      context,
                                      'Please enter your shipping address.',
                                    );
                                  } else {
                                    SnackbarUtils.showError(
                                      context,
                                      'Please select a shipping method.',
                                    );
                                  }
                                },
                          color: Colors.black,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getShippingCost() {
    final checkoutState = context.read<CheckoutBloc>().state;
    double shippingCost = 0.0;
    if (checkoutState.shippingMethodId != null &&
        checkoutState.shippingMethods.isNotEmpty) {
      final selectedMethod = checkoutState.shippingMethods.firstWhere(
        (m) => m['id'].toString() == checkoutState.shippingMethodId,
        orElse: () => <String, dynamic>{},
      );
      if (selectedMethod.isNotEmpty) {
        shippingCost = double.tryParse(selectedMethod['cost'] ?? '0') ?? 0.0;
      }
    }
    return shippingCost;
  }

  void _placeOrder(BuildContext context) {
    final billingState = context.read<BillingAddressBloc>().state;
    final shippingState = context.read<ShippingAddressBloc>().state;
    BillingInfo? billingInfo;
    ShippingInfo? shippingInfo;
    if (billingState is BillingAddressLoaded) {
      billingInfo = billingState.billingInfo;
    }
    if (shippingState is ShippingAddressLoaded) {
      shippingInfo = shippingState.shippingInfo;
    }
    if (billingInfo != null && shippingInfo != null) {
      context.read<CheckoutBloc>().add(const PlaceOrder());
    } else {
      SnackbarUtils.showError(context, 'Please complete both addresses.');
    }
  }

  // Utility function to check if shipping address is empty
  bool isShippingAddressEmpty(ShippingInfo? info) {
    if (info == null) return true;
    return info.firstName.isEmpty &&
        info.lastName.isEmpty &&
        info.phone.isEmpty &&
        info.address.isEmpty &&
        info.city.isEmpty &&
        info.state.isEmpty &&
        info.zip.isEmpty;
  }

  // Utility function to check if billing address is empty
  bool isBillingAddressEmpty(BillingInfo? info) {
    if (info == null) return true;
    return info.firstName.isEmpty &&
        info.lastName.isEmpty &&
        info.email.isEmpty &&
        info.phone.isEmpty &&
        info.address.isEmpty &&
        info.city.isEmpty &&
        info.state.isEmpty &&
        info.zip.isEmpty;
  }

  Widget _buildAddShippingAddressButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.surface,
        ),
        onPressed: () => _showAddressBottomSheet(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            Text(
              '+ Add new shipping address',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBillingAddressButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.surface,
        ),
        onPressed: () => _showBillingAddressBottomSheet(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            Text(
              '+ Add new billing address',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressForm extends StatefulWidget {
  final ShippingInfo? initialData;
  final void Function(ShippingInfo) onSave;
  const _AddressForm({this.initialData, required this.onSave});

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  String? _selectedState;

  final List<String> _states = [
    'Central',
    'Eastern',
    'Northern',
    'North Central',
    'North Western',
    'Sabaragamuwa',
    'Southern',
    'Uva',
    'Western',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.initialData?.lastName ?? '');
    _phoneController =
        TextEditingController(text: widget.initialData?.phone ?? '');
    _address1Controller =
        TextEditingController(text: widget.initialData?.address ?? '');
    _address2Controller =
        TextEditingController(); // Not in ShippingInfo, but for UI
    _cityController =
        TextEditingController(text: widget.initialData?.city ?? '');
    _zipController = TextEditingController(text: widget.initialData?.zip ?? '');
    _selectedState = widget.initialData?.state;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final shippingInfo = ShippingInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        address: _address1Controller.text, // Only address line 1 is saved
        city: _cityController.text,
        state: _selectedState ?? '',
        zip: _zipController.text,
      );
      context
          .read<ShippingAddressBloc>()
          .add(SaveShippingAddress(shippingInfo));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Add new address',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: _firstNameController,
                        label: 'First name',
                        hint: 'Enter your first name',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextFormField(
                        controller: _lastNameController,
                        label: 'Last name',
                        hint: 'Enter your last name',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _phoneController,
                  label: 'Mobile number',
                  hint: 'Enter your mobile number',
                  showLabelAboveField: true,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _address1Controller,
                  label: 'Address line 01',
                  hint: 'Enter your address line 01',
                  showLabelAboveField: true,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _address2Controller,
                  label: 'Address line 02',
                  hint: 'Enter your address line 02',
                  showLabelAboveField: true,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'Enter your city',
                  showLabelAboveField: true,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('State',
                              style: TextStyle(
                                fontSize: 15,
                              )),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _states.contains(_selectedState)
                                ? _selectedState
                                : null,
                            items: _states
                                .map((state) => DropdownMenuItem(
                                      value: state,
                                      child: Text(state),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedState = val),
                            decoration: const InputDecoration(
                              labelText: 'State',
                              hintText: 'Select state',
                              filled: true,
                              fillColor: Color(0xFFF7F7F7),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 1.5),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                              hintStyle: TextStyle(
                                  color: Color(0xFFBDBDBD), fontSize: 15),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextFormField(
                        controller: _zipController,
                        label: 'Postal code',
                        hint: 'Enter postal code',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Save address',
                  onPressed: _save,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BillingAddressForm extends StatefulWidget {
  final BillingInfo? initialData;
  final void Function(BillingInfo) onSave;
  const _BillingAddressForm({this.initialData, required this.onSave});

  @override
  State<_BillingAddressForm> createState() => _BillingAddressFormState();
}

class _BillingAddressFormState extends State<_BillingAddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  String? _selectedState;

  final List<String> _states = [
    'Central',
    'Eastern',
    'Northern',
    'North Central',
    'North Western',
    'Sabaragamuwa',
    'Southern',
    'Uva',
    'Western',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.initialData?.lastName ?? '');
    _emailController =
        TextEditingController(text: widget.initialData?.email ?? '');
    _phoneController =
        TextEditingController(text: widget.initialData?.phone ?? '');
    _address1Controller =
        TextEditingController(text: widget.initialData?.address ?? '');
    _address2Controller =
        TextEditingController(); // Not in BillingInfo, but for UI
    _cityController =
        TextEditingController(text: widget.initialData?.city ?? '');
    _zipController = TextEditingController(text: widget.initialData?.zip ?? '');
    _selectedState = widget.initialData?.state;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final billingInfo = BillingInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _address1Controller.text, // Only address line 1 is saved
        city: _cityController.text,
        state: _selectedState ?? '',
        zip: _zipController.text,
      );
      context.read<BillingAddressBloc>().add(SaveBillingAddress(billingInfo));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Add new billing address',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: _firstNameController,
                        label: 'First name',
                        hint: 'Enter your first name',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextFormField(
                        controller: _lastNameController,
                        label: 'Last name',
                        hint: 'Enter your last name',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _phoneController,
                  label: 'Mobile number',
                  hint: 'Enter your mobile number',
                  showLabelAboveField: true,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  showLabelAboveField: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _address1Controller,
                  label: 'Address line 01',
                  hint: 'Enter your address line 01',
                  showLabelAboveField: true,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _address2Controller,
                  label: 'Address line 02',
                  hint: 'Enter your address line 02',
                  showLabelAboveField: true,
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'Enter your city',
                  showLabelAboveField: true,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _states.contains(_selectedState)
                            ? _selectedState
                            : null,
                        items: _states
                            .map((state) => DropdownMenuItem(
                                  value: state,
                                  child: Text(state),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedState = val),
                        decoration: const InputDecoration(
                          labelText: 'State',
                          hintText: 'Select state',
                          filled: true,
                          fillColor: Color(0xFFF7F7F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Color(0xFFE0E0E0), width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextFormField(
                        controller: _zipController,
                        label: 'Postal code',
                        hint: 'Enter postal code',
                        showLabelAboveField: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Save address',
                  onPressed: _save,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? color;
  const _OrderSummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color:
                  isTotal ? (color ?? theme.colorScheme.primary) : Colors.black,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color:
                  isTotal ? (color ?? theme.colorScheme.primary) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBillingAddressCard(BillingInfo billingInfo, BuildContext context) {
  final theme = Theme.of(context);
  return Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.grey, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${billingInfo.firstName} ${billingInfo.lastName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  billingInfo.address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
                Text(
                  '${billingInfo.city}, ${billingInfo.state} ${billingInfo.zip}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildShippingAddressCard(
    ShippingInfo shippingInfo, BuildContext context) {
  final theme = Theme.of(context);
  return Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.grey, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${shippingInfo.firstName} ${shippingInfo.lastName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  shippingInfo.address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
                Text(
                  '${shippingInfo.city}, ${shippingInfo.state} ${shippingInfo.zip}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
