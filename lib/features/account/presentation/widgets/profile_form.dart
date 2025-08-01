import 'package:flutter/material.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController billingAddress1Controller;
  final TextEditingController billingAddress2Controller;
  final TextEditingController billingCityController;
  final TextEditingController billingStateController;
  final TextEditingController billingPostcodeController;
  final TextEditingController billingCountryController;
  final TextEditingController billingPhoneController;
  final TextEditingController shippingAddress1Controller;
  final TextEditingController shippingAddress2Controller;
  final TextEditingController shippingCityController;
  final TextEditingController shippingStateController;
  final TextEditingController shippingPostcodeController;
  final TextEditingController shippingCountryController;
  final TextEditingController shippingPhoneController;
  final bool isEditing;
  final VoidCallback onSave;
  final UserModel user;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
    required this.billingAddress1Controller,
    required this.billingAddress2Controller,
    required this.billingCityController,
    required this.billingStateController,
    required this.billingPostcodeController,
    required this.billingCountryController,
    required this.billingPhoneController,
    required this.shippingAddress1Controller,
    required this.shippingAddress2Controller,
    required this.shippingCityController,
    required this.shippingStateController,
    required this.shippingPostcodeController,
    required this.shippingCountryController,
    required this.shippingPhoneController,
    required this.isEditing,
    required this.onSave,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildBillingSection(),
            const SizedBox(height: 24),
            _buildShippingSection(),
            const SizedBox(height: 24),
            if (isEditing)
              ElevatedButton(
                onPressed: onSave,
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: emailController,
          label: 'Email',
          enabled: isEditing,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: firstNameController,
          label: 'First Name',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: lastNameController,
          label: 'Last Name',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBillingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: billingAddress1Controller,
          label: 'Address Line 1',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your billing address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: billingAddress2Controller,
          label: 'Address Line 2',
          enabled: isEditing,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                controller: billingCityController,
                label: 'City',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextFormField(
                controller: billingStateController,
                label: 'State',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                controller: billingPostcodeController,
                label: 'Postal Code',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextFormField(
                controller: billingCountryController,
                label: 'Country',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: billingPhoneController,
          label: 'Phone',
          enabled: isEditing,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: shippingAddress1Controller,
          label: 'Address Line 1',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your shipping address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: shippingAddress2Controller,
          label: 'Address Line 2',
          enabled: isEditing,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                controller: shippingCityController,
                label: 'City',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextFormField(
                controller: shippingStateController,
                label: 'State',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                controller: shippingPostcodeController,
                label: 'Postal Code',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextFormField(
                controller: shippingCountryController,
                label: 'Country',
                enabled: isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextFormField(
          controller: shippingPhoneController,
          label: 'Phone',
          enabled: isEditing,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }
} 