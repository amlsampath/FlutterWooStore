import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../checkout/domain/entities/billing_info.dart';
import '../widgets/profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // Billing fields
  final TextEditingController _billingAddress1Controller =
      TextEditingController();
  final TextEditingController _billingAddress2Controller =
      TextEditingController();
  final TextEditingController _billingCityController = TextEditingController();
  final TextEditingController _billingStateController = TextEditingController();
  final TextEditingController _billingPostcodeController =
      TextEditingController();
  final TextEditingController _billingCountryController =
      TextEditingController();
  final TextEditingController _billingPhoneController = TextEditingController();
  // Shipping fields
  final TextEditingController _shippingAddress1Controller =
      TextEditingController();
  final TextEditingController _shippingAddress2Controller =
      TextEditingController();
  final TextEditingController _shippingCityController = TextEditingController();
  final TextEditingController _shippingStateController =
      TextEditingController();
  final TextEditingController _shippingPostcodeController =
      TextEditingController();
  final TextEditingController _shippingCountryController =
      TextEditingController();
  final TextEditingController _shippingPhoneController =
      TextEditingController();
  bool _isEditing = false;
  UserModel? user;
  BillingInfo? billingInfo;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Load from local cache first
    context.read<ProfileBloc>().add(const ProfileEvent.loadProfile());
    // Then always fetch from API by customer id (if available)
    Future.microtask(() async {
      final authRepository =
          GetIt.instance<AuthRepository>() as AuthRepositoryImpl;
      final cachedUser = await authRepository.localDataSource.getUser();
      if (cachedUser != null) {
        context.read<ProfileBloc>().add(ProfileEvent.loadProfileById(customerId: cachedUser.id));
      }
    });
  }

  void _populateFields(UserModel user) {
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;

    // Populate billing fields if available
    if (user.billing != null) {
      _billingAddress1Controller.text = user.billing?['address_1'] ?? '';
      _billingAddress2Controller.text = user.billing?['address_2'] ?? '';
      _billingCityController.text = user.billing?['city'] ?? '';
      _billingStateController.text = user.billing?['state'] ?? '';
      _billingPostcodeController.text = user.billing?['postcode'] ?? '';
      _billingCountryController.text = user.billing?['country'] ?? '';
      _billingPhoneController.text = user.billing?['phone'] ?? '';
    }

    // Populate shipping fields if available
    if (user.shipping != null) {
      _shippingAddress1Controller.text = user.shipping?['address_1'] ?? '';
      _shippingAddress2Controller.text = user.shipping?['address_2'] ?? '';
      _shippingCityController.text = user.shipping?['city'] ?? '';
      _shippingStateController.text = user.shipping?['state'] ?? '';
      _shippingPostcodeController.text = user.shipping?['postcode'] ?? '';
      _shippingCountryController.text = user.shipping?['country'] ?? '';
      _shippingPhoneController.text = user.shipping?['phone'] ?? '';
    }
  }

  void _onSave(UserModel user) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedUser = user.copyWith(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      // Convert billing info to WooCommerce format
      final billing = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'address_1': _billingAddress1Controller.text.trim(),
        'address_2': _billingAddress2Controller.text.trim(),
        'city': _billingCityController.text.trim(),
        'state': _billingStateController.text.trim(),
        'postcode': _billingPostcodeController.text.trim(),
        'country': _billingCountryController.text.trim(),
        'phone': _billingPhoneController.text.trim(),
      };

      // Convert shipping info to WooCommerce format
      final shipping = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'address_1': _shippingAddress1Controller.text.trim(),
        'address_2': _shippingAddress2Controller.text.trim(),
        'city': _shippingCityController.text.trim(),
        'state': _shippingStateController.text.trim(),
        'postcode': _shippingPostcodeController.text.trim(),
        'country': _shippingCountryController.text.trim(),
        'phone': _shippingPhoneController.text.trim(),
      };

      // Update profile with billing and shipping
      context.read<ProfileBloc>().add(
            ProfileEvent.editProfile(
              updatedUser: updatedUser,
              billing: billing,
              shipping: shipping,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing && user != null) {
                _onSave(user!);
              } else {
                setState(() => _isEditing = !_isEditing);
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (user) {
              this.user = user;
              _populateFields(user);
            },
            updated: (user) {
              this.user = user;
              _populateFields(user);
              setState(() => _isEditing = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            orElse: () {
              if (user == null) {
                return const Center(child: Text('No profile data available'));
              }
              return ProfileForm(
                formKey: _formKey,
                emailController: _emailController,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                billingAddress1Controller: _billingAddress1Controller,
                billingAddress2Controller: _billingAddress2Controller,
                billingCityController: _billingCityController,
                billingStateController: _billingStateController,
                billingPostcodeController: _billingPostcodeController,
                billingCountryController: _billingCountryController,
                billingPhoneController: _billingPhoneController,
                shippingAddress1Controller: _shippingAddress1Controller,
                shippingAddress2Controller: _shippingAddress2Controller,
                shippingCityController: _shippingCityController,
                shippingStateController: _shippingStateController,
                shippingPostcodeController: _shippingPostcodeController,
                shippingCountryController: _shippingCountryController,
                shippingPhoneController: _shippingPhoneController,
                isEditing: _isEditing,
                onSave: () => _onSave(user!),
                user: user!,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _billingAddress1Controller.dispose();
    _billingAddress2Controller.dispose();
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingPostcodeController.dispose();
    _billingCountryController.dispose();
    _billingPhoneController.dispose();
    _shippingAddress1Controller.dispose();
    _shippingAddress2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostcodeController.dispose();
    _shippingCountryController.dispose();
    _shippingPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget _buildBody(ThemeData theme, bool isDark) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                // _loadUserData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (user == null && billingInfo != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildPartialProfileHeader(theme, isDark),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(theme, isDark),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                _buildMenuOption(
                  icon: Icons.person_outline,
                  title: 'Your profile',
                  onTap: () => context.push('/profile/edit'),
                  theme: theme,
                  isDestructive: false,
                ),
                _buildMenuOption(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Methods',
                  onTap: () => context.push('/payment-methods'),
                  theme: theme,
                  isDestructive: false,
                ),
                _buildMenuOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () => context.push('/orders'),
                  theme: theme,
                  isDestructive: false,
                ),
                _buildMenuOption(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => context.push('/settings'),
                  theme: theme,
                  isDestructive: false,
                ),
                _buildMenuOption(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () => context.push('/help'),
                  theme: theme,
                  isLast: true,
                  isDestructive: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              children: [
                _buildMenuOption(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => context.push('/privacy'),
                  theme: theme,
                  isDestructive: false,
                ),
                _buildMenuOption(
                  icon: Icons.people_outline,
                  title: 'Invite Friends',
                  onTap: () => context.push('/invite'),
                  theme: theme,
                  isLast: true,
                  isDestructive: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: _buildMenuOption(
              icon: Icons.logout,
              title: 'Log out',
              isLast: true,
              isDestructive: true,
              onTap: _showLogoutConfirmation,
              theme: theme,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        children: [
          // Profile Image with Edit Button
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surfaceContainerHighest,
                  image: user!.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(user!.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: user!.avatarUrl == null
                    ? Center(
                        child: Text(
                          _getInitials(user!.firstName, user!.lastName),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      )
                    : null,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: theme.scaffoldBackgroundColor, width: 2),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            '${user!.firstName} ${user!.lastName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // User Email
          Text(
            user!.email,
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartialProfileHeader(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Center(
              child: Text(
                _getInitials(
                    billingInfo?.firstName ?? '', billingInfo?.lastName ?? ''),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${billingInfo?.firstName ?? ''} ${billingInfo?.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          if (billingInfo?.email != null && billingInfo!.email.isNotEmpty)
            Text(
              billingInfo!.email,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    bool isLast = false,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? theme.colorScheme.error
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.dividerColor,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 16),
            child: Divider(
              height: 1,
              color: theme.dividerColor,
              thickness: 1,
            ),
          ),
      ],
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authRepository = GetIt.instance<AuthRepository>();
              await authRepository.logout();
              if (mounted) {
                context.pushReplacement('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    return firstName.isNotEmpty && lastName.isNotEmpty
        ? '${firstName[0]}${lastName[0]}'
        : firstName.isNotEmpty
            ? firstName[0]
            : '?';
  }
}
