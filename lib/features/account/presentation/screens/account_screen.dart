import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_app/core/constants/app_constants.dart';
import '../../../browsing_history/presentation/widgets/browsing_history_list.dart';
import '../../../browsing_history/presentation/cubit/browsing_history_cubit.dart';
import '../../../browsing_history/domain/entities/browsing_history_item.dart';
import 'package:get_it/get_it.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/data/models/user_model.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<UserModel?> _getUser() async {
    final authLocalDataSource = GetIt.I<AuthLocalDataSource>();
    return await authLocalDataSource.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text('Deleting your account, please wait...')),
                ],
              ),
            ),
          );
        } else {
          // Always try to pop progress dialog if open
          Navigator.of(context, rootNavigator: true)
              .popUntil((route) => route.isFirst || !route.isCurrent);
        }
        if (state is Unauthenticated) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Account Deleted'),
              content:
                  const Text('Your account has been deleted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    context.go('/login');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: FutureBuilder<UserModel?>(
          future: _getUser(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            final user = snapshot.data;
            if (user != null) {
              return _buildAuthenticatedContent(context, user, theme, isDark);
            } else {
              return _buildUnauthenticatedContent(context, theme);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuthenticatedContent(
      BuildContext context, UserModel user, ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, user, theme),
          //   const SizedBox(height: 24),
          _buildOrdersSection(context),

          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),

          _buildMenuCard(
            context,
            theme: theme,
            isDark: isDark,
            items: [
              MenuItemData(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () => context.push('/customer-profile'),
              ),
              MenuItemData(
                icon: Icons.shopping_bag_outlined,
                title: 'Orders',
                onTap: () => context.push('/orders'),
              ),
              MenuItemData(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                onTap: () => _showDeleteAccountConfirmation(context, user.id),
              ),
            ],
          ),

          BlocBuilder<BrowsingHistoryCubit, List<BrowsingHistoryItem>>(
            builder: (context, history) => BrowsingHistoryList(
              items: history,
              onTap: (item) {
                context.push('/product/${item.id}');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, UserModel user, ThemeData theme) {
    final topPadding = MediaQuery.of(context).padding.top + 16;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Stack(
        children: [
          Image.asset(
            'assets/profile/bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/profile/shadow.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'HI, ${user.firstName}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    // width: 120,
                    // height: 40,
                    child: ElevatedButton(
                      onPressed: () => _showLogoutConfirmation(context),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xFFB9802A)),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(0),
                      ),
                      child: const Text('Log out'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context) {
    const iconColor = Color(0xFF9B6A2F);
    const labelStyle = TextStyle(
      fontSize: 13,
      color: iconColor,
      fontWeight: FontWeight.w400,
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {}, // TODO: Implement see all navigation
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _OrderIconLabel(
                asset: 'assets/profile/wallet-2.svg',
                label: 'To pay',
              ),
              _OrderIconLabel(
                asset: 'assets/profile/Toship.svg',
                label: 'To ship',
              ),
              _OrderIconLabel(
                asset: 'assets/profile/Shipped.svg',
                label: 'Shipped',
              ),
              _OrderIconLabel(
                asset: 'assets/profile/toreview.svg',
                label: 'To review',
              ),
              _OrderIconLabel(
                asset: 'assets/profile/Return.svg',
                label: 'Returns',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required ThemeData theme,
    required bool isDark,
    required List<MenuItemData> items,
  }) {
    return Container(
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
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) => _buildMenuItem(
            context,
            item: items[index],
            isLast: index == items.length - 1,
            theme: theme,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required MenuItemData item,
    required bool isLast,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
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
                  item.icon,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
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

  Widget _buildLogoutButton(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
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
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showLogoutConfirmation(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(Logout());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              children: [
                Image.asset(
                  'assets/profile/bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/profile/shadow.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Top profile section
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Welcome to ${AppConstants.appName}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.appDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB9802A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Sign in/ Register'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildOrdersSection(context),
          BlocBuilder<BrowsingHistoryCubit, List<BrowsingHistoryItem>>(
            builder: (context, history) => BrowsingHistoryList(
              items: history,
              onTap: (item) {
                context.push('/product/${item.id}');
              },
            ),
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

  void _showDeleteAccountConfirmation(BuildContext context, int customerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(DeleteAccount(customerId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

// Helper widget for icon + label
class _OrderIconLabel extends StatelessWidget {
  final String asset;
  final String label;
  const _OrderIconLabel({required this.asset, required this.label});
  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF9B6A2F);
    return Column(
      children: [
        SvgPicture.asset(
          asset,
          width: 32,
          height: 32,
          color: iconColor,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: iconColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
