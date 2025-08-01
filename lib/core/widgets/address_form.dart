import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../../features/checkout/domain/entities/shipping_info.dart';
import '../../features/checkout/domain/entities/billing_info.dart';

class AddressForm extends StatefulWidget {
  final dynamic initialData; // ShippingInfo or BillingInfo
  final String type; // 'shipping' or 'billing'
  final void Function(dynamic)
      onSave; // Callback with ShippingInfo or BillingInfo

  const AddressForm({
    super.key,
    this.initialData,
    required this.type,
    required this.onSave,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.initialData?.lastName ?? '');
    _phoneController =
        TextEditingController(text: widget.initialData?.phone ?? '');
    _addressController =
        TextEditingController(text: widget.initialData?.address ?? '');
    _cityController =
        TextEditingController(text: widget.initialData?.city ?? '');
    _stateController =
        TextEditingController(text: widget.initialData?.state ?? '');
    _zipController = TextEditingController(text: widget.initialData?.zip ?? '');
    _emailController =
        TextEditingController(text: widget.initialData?.email ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.type == 'shipping') {
        widget.onSave(
          ShippingInfo(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            city: _cityController.text,
            state: _stateController.text,
            zip: _zipController.text,
          ),
        );
      } else {
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingS),
            if (widget.type == 'billing')
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            const SizedBox(height: AppDimensions.spacingS),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(labelText: 'ZIP'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: Text(
                    'Save ${widget.type == 'shipping' ? 'Shipping' : 'Billing'} Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
