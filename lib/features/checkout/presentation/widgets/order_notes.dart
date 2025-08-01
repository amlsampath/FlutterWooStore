import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkout_bloc.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';

class OrderNotes extends StatefulWidget {
  const OrderNotes({super.key});

  @override
  State<OrderNotes> createState() => _OrderNotesState();
}

class _OrderNotesState extends State<OrderNotes> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: appTheme.borderRadiusM,
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: appTheme.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Notes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppTextFormField(
              controller: _controller,
              label: 'Special Instructions',
              hint: 'Add any special instructions or delivery notes...',
              onChanged: (value) {
                context.read<CheckoutBloc>().add(UpdateOrderNotes(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
