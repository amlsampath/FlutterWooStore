import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkout_bloc.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/snackbar_utils.dart';

class BillingForm extends StatefulWidget {
  final BillingInfo? initialData;
  final ShippingInfo? initialShippingData;

  const BillingForm({
    Key? key,
    this.initialData,
    this.initialShippingData,
  }) : super(key: key);

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  // Shipping controllers
  late TextEditingController _shippingFirstNameController;
  late TextEditingController _shippingLastNameController;
  late TextEditingController _shippingPhoneController;
  late TextEditingController _shippingAddressController;
  late TextEditingController _shippingCityController;
  late TextEditingController _shippingStateController;
  late TextEditingController _shippingZipController;

  bool _isDisposed = false;
  bool _useShippingAsBilling =
      true; // Renamed for clarity - means use billing address for shipping
  bool _hasBillingData = false; // Track if we have billing data

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Check if we have initial billing data
    _hasBillingData = widget.initialData != null &&
        widget.initialData!.firstName.isNotEmpty &&
        widget.initialData!.lastName.isNotEmpty;

    // Force update UI if we have billing info
    if (_hasBillingData) {
      setState(() {});
    }

    // Listen for billing info updates
    context.read<CheckoutBloc>().stream.listen((state) {
      if (state.billingInfo != null && !_isDisposed) {
        _updateControllers(state.billingInfo!);
        setState(() {
          _hasBillingData = state.billingInfo!.firstName.isNotEmpty &&
              state.billingInfo!.lastName.isNotEmpty;
        });
      }

      // Update shipping controllers if available
      if (state.shippingInfo != null && !_isDisposed) {
        _updateShippingControllers(state.shippingInfo!);

        // Determine if shipping is same as billing
        if (state.billingInfo != null) {
          setState(() {
            _useShippingAsBilling =
                _isSameAddress(state.billingInfo, state.shippingInfo);
          });
        }
      }
    });
  }

  void _initializeControllers() {
    final initialData = widget.initialData;
    final initialShipping = widget.initialShippingData;

    // Billing
    _firstNameController =
        TextEditingController(text: initialData?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: initialData?.lastName ?? '');
    _emailController = TextEditingController(text: initialData?.email ?? '');
    _phoneController = TextEditingController(text: initialData?.phone ?? '');
    _addressController =
        TextEditingController(text: initialData?.address ?? '');
    _cityController = TextEditingController(text: initialData?.city ?? '');
    _stateController = TextEditingController(text: initialData?.state ?? '');
    _zipController = TextEditingController(text: initialData?.zip ?? '');

    // Shipping
    _shippingFirstNameController = TextEditingController(
        text: initialShipping?.firstName ?? initialData?.firstName ?? '');
    _shippingLastNameController = TextEditingController(
        text: initialShipping?.lastName ?? initialData?.lastName ?? '');
    _shippingPhoneController = TextEditingController(
        text: initialShipping?.phone ?? initialData?.phone ?? '');
    _shippingAddressController = TextEditingController(
        text: initialShipping?.address ?? initialData?.address ?? '');
    _shippingCityController = TextEditingController(
        text: initialShipping?.city ?? initialData?.city ?? '');
    _shippingStateController = TextEditingController(
        text: initialShipping?.state ?? initialData?.state ?? '');
    _shippingZipController = TextEditingController(
        text: initialShipping?.zip ?? initialData?.zip ?? '');

    // Determine if we should show separate shipping address
    if (initialShipping != null && initialData != null) {
      _useShippingAsBilling = _isSameAddress(initialData, initialShipping);
    }

    // Check if we have initial billing data
    _hasBillingData = initialData != null &&
        initialData.firstName.isNotEmpty &&
        initialData.lastName.isNotEmpty;
  }

  bool _isSameAddress(BillingInfo? billing, ShippingInfo? shipping) {
    if (billing == null || shipping == null) return true;

    return billing.firstName == shipping.firstName &&
        billing.lastName == shipping.lastName &&
        billing.phone == shipping.phone &&
        billing.address == shipping.address &&
        billing.city == shipping.city &&
        billing.state == shipping.state &&
        billing.zip == shipping.zip;
  }

  void _updateControllers(BillingInfo info) {
    if (_isDisposed) return;

    _firstNameController.text = info.firstName;
    _lastNameController.text = info.lastName;
    _emailController.text = info.email;
    _phoneController.text = info.phone;
    _addressController.text = info.address;
    _cityController.text = info.city;
    _stateController.text = info.state;
    _zipController.text = info.zip;

    // Update shipping controllers too if using same address
    if (_useShippingAsBilling) {
      _shippingFirstNameController.text = info.firstName;
      _shippingLastNameController.text = info.lastName;
      _shippingPhoneController.text = info.phone;
      _shippingAddressController.text = info.address;
      _shippingCityController.text = info.city;
      _shippingStateController.text = info.state;
      _shippingZipController.text = info.zip;
    }
  }

  void _updateShippingControllers(ShippingInfo info) {
    if (_isDisposed) return;

    _shippingFirstNameController.text = info.firstName;
    _shippingLastNameController.text = info.lastName;
    _shippingPhoneController.text = info.phone;
    _shippingAddressController.text = info.address;
    _shippingCityController.text = info.city;
    _shippingStateController.text = info.state;
    _shippingZipController.text = info.zip;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();

    _shippingFirstNameController.dispose();
    _shippingLastNameController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddressController.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingZipController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Billing Information
          Text(
            'Billing Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'Enter your first name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onChanged: (_) => _updateBillingInfoInBloc(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: AppTextFormField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onChanged: (_) => _updateBillingInfoInBloc(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          AppTextFormField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (_) => _updateBillingInfoInBloc(),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          AppTextFormField(
            controller: _phoneController,
            label: 'Phone',
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            onChanged: (_) => _updateBillingInfoInBloc(),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          AppTextFormField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter your address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
            onChanged: (_) => _updateBillingInfoInBloc(),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          AppTextFormField(
            controller: _cityController,
            label: 'City',
            hint: 'Enter your city',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
            onChanged: (_) => _updateBillingInfoInBloc(),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: _stateController,
                  label: 'State/Province',
                  hint: 'Enter your state',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                  onChanged: (_) => _updateBillingInfoInBloc(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: AppTextFormField(
                  controller: _zipController,
                  label: 'ZIP/Postal Code',
                  hint: 'Enter your ZIP code',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ZIP code';
                    }
                    return null;
                  },
                  onChanged: (_) => _updateBillingInfoInBloc(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXL),

          // Shipping Information
          Row(
            children: [
              Text(
                'Delivery Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: _useShippingAsBilling,
                onChanged: (value) {
                  setState(() {
                    _useShippingAsBilling = value;

                    // If switched to same address, copy billing to shipping
                    if (_useShippingAsBilling) {
                      _shippingFirstNameController.text =
                          _firstNameController.text;
                      _shippingLastNameController.text =
                          _lastNameController.text;
                      _shippingPhoneController.text = _phoneController.text;
                      _shippingAddressController.text = _addressController.text;
                      _shippingCityController.text = _cityController.text;
                      _shippingStateController.text = _stateController.text;
                      _shippingZipController.text = _zipController.text;

                      _updateShippingInfoInBloc();
                    }
                  });
                },
                activeColor: theme.colorScheme.primary,
              ),
              Text(
                _useShippingAsBilling ? 'Same as billing' : 'Different address',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),

          if (!_useShippingAsBilling) ...[
            const SizedBox(height: AppDimensions.spacingM),
            const Divider(),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _shippingFirstNameController,
                    label: 'First Name',
                    hint: 'Enter recipient first name',
                    validator: (value) {
                      if (!_useShippingAsBilling &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter recipient first name';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateShippingInfoInBloc(),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: AppTextFormField(
                    controller: _shippingLastNameController,
                    label: 'Last Name',
                    hint: 'Enter recipient last name',
                    validator: (value) {
                      if (!_useShippingAsBilling &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter recipient last name';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateShippingInfoInBloc(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _shippingPhoneController,
              label: 'Phone',
              hint: 'Enter recipient phone number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (!_useShippingAsBilling &&
                    (value == null || value.isEmpty)) {
                  return 'Please enter recipient phone number';
                }
                return null;
              },
              onChanged: (_) => _updateShippingInfoInBloc(),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _shippingAddressController,
              label: 'Delivery Address',
              hint: 'Enter delivery address',
              validator: (value) {
                if (!_useShippingAsBilling &&
                    (value == null || value.isEmpty)) {
                  return 'Please enter delivery address';
                }
                return null;
              },
              onChanged: (_) => _updateShippingInfoInBloc(),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _shippingCityController,
              label: 'City',
              hint: 'Enter city',
              validator: (value) {
                if (!_useShippingAsBilling &&
                    (value == null || value.isEmpty)) {
                  return 'Please enter city';
                }
                return null;
              },
              onChanged: (_) => _updateShippingInfoInBloc(),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: _shippingStateController,
                    label: 'State/Province',
                    hint: 'Enter state',
                    validator: (value) {
                      if (!_useShippingAsBilling &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateShippingInfoInBloc(),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: AppTextFormField(
                    controller: _shippingZipController,
                    label: 'ZIP/Postal Code',
                    hint: 'Enter ZIP code',
                    validator: (value) {
                      if (!_useShippingAsBilling &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter ZIP code';
                      }
                      return null;
                    },
                    onChanged: (_) => _updateShippingInfoInBloc(),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppDimensions.spacingL),
          AppElevatedButton(
            text: 'Save Billing Information',
            onPressed: _saveBillingInfo,
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
          ),
        ],
      ),
    );
  }

  void _updateBillingInfoInBloc() {
    final billingInfo = BillingInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      state: _stateController.text,
      zip: _zipController.text,
    );

    context.read<CheckoutBloc>().add(UpdateBillingInfo(billingInfo));

    // Update the billing data flag
    setState(() {
      _hasBillingData = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    });

    // If using same address for shipping, update that too
    if (_useShippingAsBilling) {
      final shippingInfo = ShippingInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        zip: _zipController.text,
      );

      context.read<CheckoutBloc>().add(UpdateShippingInfo(shippingInfo));
    }
  }

  void _updateShippingInfoInBloc() {
    final shippingInfo = ShippingInfo(
      firstName: _shippingFirstNameController.text,
      lastName: _shippingLastNameController.text,
      phone: _shippingPhoneController.text,
      address: _shippingAddressController.text,
      city: _shippingCityController.text,
      state: _shippingStateController.text,
      zip: _shippingZipController.text,
    );

    context.read<CheckoutBloc>().add(UpdateShippingInfo(shippingInfo));
  }

  void _saveBillingInfo() {
    if (_formKey.currentState!.validate()) {
      final billingInfo = BillingInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        zip: _zipController.text,
      );

      context.read<CheckoutBloc>().add(SaveBillingInfo(billingInfo));

      // Also save shipping info
      final shippingInfo = ShippingInfo(
        firstName: _useShippingAsBilling
            ? _firstNameController.text
            : _shippingFirstNameController.text,
        lastName: _useShippingAsBilling
            ? _lastNameController.text
            : _shippingLastNameController.text,
        phone: _useShippingAsBilling
            ? _phoneController.text
            : _shippingPhoneController.text,
        address: _useShippingAsBilling
            ? _addressController.text
            : _shippingAddressController.text,
        city: _useShippingAsBilling
            ? _cityController.text
            : _shippingCityController.text,
        state: _useShippingAsBilling
            ? _stateController.text
            : _shippingStateController.text,
        zip: _useShippingAsBilling
            ? _zipController.text
            : _shippingZipController.text,
      );

      context.read<CheckoutBloc>().add(SaveShippingInfo(shippingInfo));

      SnackbarUtils.showSuccess(
        context,
        'Billing and shipping information saved',
      );
    }
  }
}
