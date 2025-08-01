import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/app_outlined_button.dart';
import '../../../../core/widgets/address_card.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/bottom_sheet_utils.dart';
import '../bloc/checkout_bloc.dart';
import '../../domain/entities/billing_info.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved billing info
    context.read<CheckoutBloc>().add(LoadBillingInfo());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Billing Information',
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess && state.billingInfo != null) {
            // Show success message when billing info is saved
            if (state.orderDetails == null) {
              SnackbarUtils.showSuccess(
                context,
                'Billing information saved successfully',
              );
            }
          } else if (state is CheckoutError) {
            SnackbarUtils.showError(
              context,
              state.error ?? 'An error occurred',
            );
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Billing Information',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                if (state.billingInfo != null &&
                    state.billingInfo!.address.isNotEmpty &&
                    state.billingInfo!.city.isNotEmpty)
                  AddressCard(
                    address: state.billingInfo!.address,
                    city: state.billingInfo!.city,
                    state: state.billingInfo!.state,
                    zip: state.billingInfo!.zip,
                    firstName: state.billingInfo!.firstName,
                    lastName: state.billingInfo!.lastName,
                    leadingIcon: Icons.business_outlined,
                    trailingButtonText: 'CHANGE',
                    onTrailingButtonPressed: () =>
                        _showBillingAddressBottomSheet(
                      initialData: state.billingInfo,
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: AppOutlinedButton.icon(
                      icon: Icons.add,
                      text: 'Add New Billing Address',
                      onPressed: () => _showBillingAddressBottomSheet(),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spacingL),
                AppElevatedButton(
                  text: 'Return to Profile',
                  onPressed: () => context.pop(),
                  minimumSize:
                      const Size.fromHeight(AppDimensions.buttonHeightL),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBillingAddressBottomSheet({BillingInfo? initialData}) {
    BottomSheetUtils.showForm(
      context: context,
      child: _BillingAddressForm(
        initialData: initialData,
        onSave: (info) {
          context.read<CheckoutBloc>().add(SaveBillingInfo(info));
          Navigator.pop(context);
          SnackbarUtils.showSuccess(
            context,
            'Billing information saved successfully',
          );
        },
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
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

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
    _addressController =
        TextEditingController(text: widget.initialData?.address ?? '');
    _cityController =
        TextEditingController(text: widget.initialData?.city ?? '');
    _stateController =
        TextEditingController(text: widget.initialData?.state ?? '');
    _zipController = TextEditingController(text: widget.initialData?.zip ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _saveBillingInfo() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        BillingInfo(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          city: _cityController.text,
          state: _stateController.text,
          zip: _zipController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Billing Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _firstNameController,
                    label: 'First Name',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: AppTextFormField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v!.isEmpty) return 'Required';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _phoneController,
              label: 'Phone',
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _addressController,
              label: 'Address',
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _cityController,
                    label: 'City',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: AppTextFormField(
                    controller: _stateController,
                    label: 'State',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: AppTextFormField(
                    controller: _zipController,
                    label: 'ZIP',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingL),
            AppElevatedButton(
              text: 'Save Billing Address',
              onPressed: _saveBillingInfo,
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
            ),
          ],
        ),
      ),
    );
  }
}
