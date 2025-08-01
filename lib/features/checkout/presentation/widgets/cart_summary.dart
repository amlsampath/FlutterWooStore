// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../cart/presentation/bloc/cart_bloc.dart';

// class CartSummary extends StatelessWidget {
//   const CartSummary({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartBloc, CartState>(
//       builder: (context, state) {
//         if (state is CartLoaded) {
//           return Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Order Summary',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ...state.items.map((item) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '${item.name} x ${item.quantity}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           Text(
//                             '\$${(double.parse(item.price) * item.quantity).toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                   const Divider(),
//                   _buildTotalRow('Subtotal', state.subtotal),
//                   if (state.tax > 0) _buildTotalRow('Tax', state.tax),
//                   if (state.discount > 0)
//                     _buildTotalRow('Discount', -state.discount),
//                   _buildTotalRow('Shipping', state.shipping),
//                   const Divider(),
//                   _buildTotalRow(
//                     'Total',
//                     state.total,
//                     isTotal: true,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 16,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             '\$${amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 16,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
