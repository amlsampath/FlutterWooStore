import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../checkout/domain/entities/order_item.dart';
import '../../../checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecommerce_app/core/utils/currency_formatter.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? _overrideStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read status from GoRouter extra if present
    final extra = GoRouterState.of(context).extra;
    if (extra is Map && extra['status'] is String) {
      _overrideStatus = extra['status'] as String;
    }
    _loadOrderDetails();
  }

  void _loadOrderDetails() {
    context.read<CheckoutBloc>().add(GetOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderDetailsLoaded) {
            final orderDetails = state.orderDetails;
            final order = orderDetails.order;
            final status = _overrideStatus ?? order.status;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderStatusCard(status),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Order Items'),
                  ...orderDetails.items
                      .map((item) => _buildOrderItemCard(item)),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Shipping Information'),
                  _buildAddressCard(order.billingInfo),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Payment Summary'),
                  _buildPaymentSummaryCard(order),
                  if (orderDetails.customerNote != null &&
                      orderDetails.customerNote!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Order Notes'),
                    _buildNotesCard(orderDetails.customerNote!),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          if (state is CheckoutError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading order details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error ?? 'An unknown error occurred',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadOrderDetails,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Fallback loading state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard(String status) {
    // Determine order status color
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'on-hold':
        statusColor = Colors.orange;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      case 'refunded':
        statusColor = Colors.purple;
        break;
      case 'failed':
        statusColor = Colors.red.shade900;
        break;
      case 'pending':
      default:
        statusColor = Colors.grey;
        break;
    }

    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(status),
              color: statusColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusDescription(status),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItem item) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity} x ${CurrencyFormatter.formatPrice(item.price)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${CurrencyFormatter.formatPrice(item.total)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(billingInfo) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('${billingInfo.firstName} ${billingInfo.lastName}'),
            Text(billingInfo.address),
            Text(
                '${billingInfo.city}, ${billingInfo.state} ${billingInfo.zip}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(billingInfo.phone),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(billingInfo.email),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard(order) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Payment Method: ${order.paymentMethodTitle}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPriceRow(
                'Subtotal', CurrencyFormatter.formatPrice(order.subtotal)),
            _buildPriceRow(
                'Shipping', CurrencyFormatter.formatPrice(order.shippingTotal)),
            _buildPriceRow('Tax', CurrencyFormatter.formatPrice(order.tax)),
            if (order.discountTotal != null && order.discountTotal != '0.00')
              _buildPriceRow('Discount',
                  '-${CurrencyFormatter.formatPrice(order.discountTotal)}'),
            const Divider(),
            _buildPriceRow(
              'Total',
              CurrencyFormatter.formatPrice(order.total),
              valueStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(String notes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.note,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(notes),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'processing':
        return Icons.sync;
      case 'on-hold':
        return Icons.pause_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.money;
      case 'failed':
        return Icons.error;
      case 'pending':
      default:
        return Icons.hourglass_empty;
    }
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Your order has been successfully delivered.';
      case 'processing':
        return 'Your order is being processed for shipping.';
      case 'on-hold':
        return 'Your order is on hold. We\'ll contact you if needed.';
      case 'cancelled':
        return 'This order has been cancelled.';
      case 'refunded':
        return 'Your payment has been refunded.';
      case 'failed':
        return 'Order processing failed. Please contact support.';
      case 'pending':
      default:
        return 'Your order is pending payment confirmation.';
    }
  }
}
