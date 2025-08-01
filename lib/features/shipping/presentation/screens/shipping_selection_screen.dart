import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../bloc/shipping_bloc.dart';
import '../../domain/entities/shipping_zone.dart';

class ShippingSelectionScreen extends StatelessWidget {
  const ShippingSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.background : AppColors.surface,
      appBar: const AppAppBar(
        title: 'Select Shipping Method',
      ),
      body: BlocConsumer<ShippingBloc, ShippingState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoadingIndicator();
          }

          if (state.error != null) {
            return AppErrorState(
              message: state.error!,
              onRetry: () {
                context.read<ShippingBloc>().add(LoadShippingZones());
              },
            );
          }

          if (state.zones.isEmpty) {
            return const AppLoadingIndicator();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            itemCount: state.zones.length,
            itemBuilder: (context, index) {
              final zone = state.zones[index];
              return _buildShippingZoneCard(context, zone, state);
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ShippingBloc, ShippingState>(
        builder: (context, state) {
          if (state.selectedMethod == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: AppElevatedButton(
                text: 'Continue to Payment',
                onPressed: () {
                  // context.read<CheckoutBloc>().add(
                  //       UpdateShippingMethod(state.selectedMethod!.methodId),
                  //     );
                  context.push('/checkout/payment', extra: {
                    'shippingMethodId': state.selectedMethod!.methodId
                  });
                },
                minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShippingZoneCard(
    BuildContext context,
    ShippingZone zone,
    ShippingState state,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      color: isDarkMode ? AppColors.surface : AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              zone.name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            if (zone.methods.isEmpty)
              const AppEmptyView(
                message: 'No shipping methods available for this zone',
                icon: Icons.local_shipping_outlined,
              )
            else
              ...zone.methods.map((method) {
                return RadioListTile<ShippingMethod>(
                  title: Text(
                    method.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    method.description ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: method,
                  groupValue: state.selectedMethod,
                  activeColor: AppColors.primary,
                  onChanged: method.enabled
                      ? (value) {
                          if (value != null) {
                            context.read<ShippingBloc>().add(
                                  SelectShippingMethod(
                                    method: value,
                                    zone: zone,
                                  ),
                                );
                          }
                        }
                      : null,
                );
              }),
          ],
        ),
      ),
    );
  }
}
