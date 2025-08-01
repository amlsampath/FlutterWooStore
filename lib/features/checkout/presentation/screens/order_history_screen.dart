// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../bloc/checkout_bloc.dart';
// import '../../domain/entities/order.dart';
// import 'order_summary_screen.dart';
// import 'package:ecommerce_app/core/utils/currency_formatter.dart';
// import '../../domain/repositories/checkout_repository.dart';

// class OrderHistoryScreen extends StatelessWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order History'),
//       ),
//       body: BlocBuilder<CheckoutBloc, CheckoutState>(
//         builder: (context, state) {
//           if (state is OrderHistoryLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is OrderHistoryLoaded) {
//             if (state.orders.isEmpty) {
//               return const Center(
//                 child: Text('No orders found'),
//               );
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: state.orders.length,
//               itemBuilder: (context, index) {
//                 final order = state.orders[index];
//                 return _buildOrderCard(context, order);
//               },
//             );
//           }

//           if (state is OrderHistoryError) {
//             return Center(
//               child: Text(state.error ?? 'Failed to load orders'),
//             );
//           }

//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   Widget _buildOrderCard(BuildContext context, Order order) {
//     final dateFormat = DateFormat('MMM d, yyyy');

//     Widget _buildOrderDetail(String label, String value) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ],
//       );
//     }

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OrderSummaryScreen(
//                 orderDetails: {
//                   'id': order.id,
//                   'status': order.status,
//                   'total': order.total,
//                   'subtotal': order.subtotal,
//                   'tax': order.tax,
//                   'shipping_total': order.shippingTotal,
//                   'discount_total': order.discountTotal,
//                   'payment_method': order.paymentMethod,
//                   'payment_method_title': order.paymentMethodTitle,
//                 },
//                 billingInfo: order.billingInfo,
//               ),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Order #${order.id}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   _buildStatusChip(order.status),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Placed on ${dateFormat.format(order.dateCreated)}',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               const SizedBox(height: 8),
//               _buildOrderDetail('Payment Method', order.paymentMethodTitle),
//               _buildOrderDetail(
//                   'Subtotal', CurrencyFormatter.formatPrice(order.subtotal)),
//               _buildOrderDetail('Shipping',
//                   CurrencyFormatter.formatPrice(order.shippingTotal)),
//               _buildOrderDetail(
//                   'Tax', CurrencyFormatter.formatPrice(order.tax)),
//               const Divider(),
//               _buildOrderDetail(
//                 'Total',
//                 CurrencyFormatter.formatPrice(order.total),
//               ),
//               const SizedBox(height: 8),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => OrderSummaryScreen(
//                           orderDetails: {
//                             'id': order.id,
//                             'status': order.status,
//                             'total': order.total,
//                             'subtotal': order.subtotal,
//                             'tax': order.tax,
//                             'shipping_total': order.shippingTotal,
//                             'discount_total': order.discountTotal,
//                             'payment_method': order.paymentMethod,
//                             'payment_method_title': order.paymentMethodTitle,
//                           },
//                           billingInfo: order.billingInfo,
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('View Details'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color;
//     switch (status.toLowerCase()) {
//       case 'completed':
//         color = Colors.green;
//         break;
//       case 'processing':
//         color = Colors.blue;
//         break;
//       case 'on-hold':
//         color = Colors.orange;
//         break;
//       case 'cancelled':
//         color = Colors.red;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Chip(
//       label: Text(
//         status.toUpperCase(),
//         style: TextStyle(
//           color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//         ),
//       ),
//       backgroundColor: color.withOpacity(0.2),
//     );
//   }
// }
