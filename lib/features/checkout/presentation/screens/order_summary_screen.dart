import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/billing_info.dart';
import 'package:ecommerce_app/core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/theme/app_theme_extension.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> orderDetails;
  final BillingInfo billingInfo;

  const OrderSummaryScreen({
    super.key,
    required this.orderDetails,
    required this.billingInfo,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appTheme = theme.appThemeExtension;

    return WillPopScope(
      onWillPop: () async {
        context.push('/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // Enhanced Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 56, bottom: 24), // Reduced from 40 to 24
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.8),
                    colorScheme.primary.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Success icon with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 64, // Reduced from 80 to 64
                      height: 64, // Reduced from 80 to 64
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 32, // Reduced from 40 to 32
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced from 16 to 12
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Order summary',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24, // Reduced from 28 to 24
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Enhanced Confirmation Card
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset:
                                const Offset(0, -20), // Reduced from -30 to -20
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 16), // Reduced from 24 to 16
                              child: Card(
                                elevation: 8,
                                shadowColor:
                                    colorScheme.primary.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Reduced from 24 to 20
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        20), // Reduced from 24 to 20
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Colors.grey.shade50,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        20), // Reduced from 24 to 20
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Enhanced success icon
                                        Container(
                                          width: 60, // Reduced from 72 to 60
                                          height: 60, // Reduced from 72 to 60
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green.shade400,
                                                Colors.green.shade600,
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 30, // Reduced from 36 to 30
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                16), // Reduced from 20 to 16
                                        Text(
                                          'Order #${widget.orderDetails['id']} is confirmed!',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height: 6), // Reduced from 8 to 6
                                        Text(
                                          'Thank you for your purchase. We\'ll send you updates on your order status.',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.grey.shade600,
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                            height:
                                                20), // Reduced from 24 to 20
                                        // Enhanced divider
                                        Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.grey.shade300,
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                20), // Reduced from 24 to 20
                                        // Order Details Section
                                        _buildOrderDetailsSection(context),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // Enhanced Continue Shopping Button
            Container(
              padding: const EdgeInsets.fromLTRB(
                  20, 12, 20, 24), // Reduced top padding from 16 to 12
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppPrimaryButton(
                label: 'Continue shopping',
                onPressed: () => context.go('/home'),
                color: colorScheme.primary,
                borderRadius: 14, // Reduced from 16 to 14
                height: 52, // Reduced from 56 to 52
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15, // Reduced from 16 to 15
                ),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.receipt_long,
              color: theme.colorScheme.primary,
              size: 18, // Reduced from 20 to 18
            ),
            const SizedBox(width: 6), // Reduced from 8 to 6
            Text(
              'Order Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12), // Reduced from 16 to 12
        // Enhanced order items
        ..._buildEnhancedOrderItems(context),
        const SizedBox(height: 16), // Reduced from 20 to 16
        // Enhanced summary table
        _buildEnhancedSummaryTable(context),
      ],
    );
  }

  List<Widget> _buildEnhancedOrderItems(BuildContext context) {
    final theme = Theme.of(context);
    final lineItems =
        (widget.orderDetails['line_items'] as List<dynamic>?) ?? [];

    if (lineItems.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              Text(
                'No items found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return lineItems.map((item) {
      final map = item as Map<String, dynamic>;
      return Container(
        margin: const EdgeInsets.only(bottom: 8), // Reduced from 12 to 8
        padding: const EdgeInsets.all(12), // Reduced from 16 to 12
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Reduced from 12 to 10
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product icon
            Container(
              width: 40, // Reduced from 48 to 40
              height: 40, // Reduced from 48 to 40
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6), // Reduced from 8 to 6
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: theme.colorScheme.primary,
                size: 20, // Reduced from 24 to 20
              ),
            ),
            const SizedBox(width: 12), // Reduced from 16 to 12
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map['name'] ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (map['quantity'] != null) ...[
                    const SizedBox(height: 3), // Reduced from 4 to 3
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, // Reduced from 8 to 6
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(4), // Reduced from 6 to 4
                      ),
                      child: Text(
                        'Qty: ${map['quantity']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12), // Reduced from 16 to 12
            Text(
              _formatCurrency(map['total']),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEnhancedSummaryTable(BuildContext context) {
    final theme = Theme.of(context);
    double subtotal = 0.0;
    final lineItems =
        (widget.orderDetails['line_items'] as List<dynamic>?) ?? [];

    for (final item in lineItems) {
      final totalStr =
          (item as Map<String, dynamic>)['total']?.toString() ?? '0';
      subtotal += double.tryParse(totalStr) ?? 0.0;
    }

    final tax =
        double.tryParse(widget.orderDetails['total_tax']?.toString() ?? '0') ??
            0.0;
    final shipping = double.tryParse(
            widget.orderDetails['shipping_total']?.toString() ?? '0') ??
        0.0;
    final discount = double.tryParse(
            widget.orderDetails['discount_total']?.toString() ?? '0') ??
        0.0;
    final total =
        double.tryParse(widget.orderDetails['total']?.toString() ?? '0') ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16), // Reduced from 20 to 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // Reduced from 16 to 14
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedSummaryRow(context, 'Subtotal',
              _formatCurrency(subtotal), Icons.shopping_cart_outlined),
          const SizedBox(height: 10), // Reduced from 12 to 10
          _buildEnhancedSummaryRow(
              context, 'Tax', _formatCurrency(tax), Icons.receipt_outlined),
          const SizedBox(height: 10), // Reduced from 12 to 10
          _buildEnhancedSummaryRow(context, 'Shipping',
              _formatCurrency(shipping), Icons.local_shipping_outlined),
          if (discount > 0) ...[
            const SizedBox(height: 10), // Reduced from 12 to 10
            _buildEnhancedSummaryRow(context, 'Discount',
                '-${_formatCurrency(discount)}', Icons.discount_outlined,
                isDiscount: true),
          ],
          const SizedBox(height: 12), // Reduced from 16 to 12
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 12), // Reduced from 16 to 12
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: theme.colorScheme.primary,
                    size: 18, // Reduced from 20 to 18
                  ),
                  const SizedBox(width: 6), // Reduced from 8 to 6
                  Text(
                    'Total',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Text(
                _formatCurrency(total),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 22, // Reduced from 24 to 22
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isDiscount = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          color: isDiscount ? Colors.green.shade600 : Colors.grey.shade600,
          size: 16, // Reduced from 18 to 16
        ),
        const SizedBox(width: 8), // Reduced from 12 to 8
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green.shade600 : Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(dynamic value) {
    return CurrencyFormatter.formatPrice(value?.toString() ?? '0');
  }
}
