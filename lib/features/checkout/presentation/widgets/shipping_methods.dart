// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/checkout_bloc.dart';

// class ShippingMethods extends StatelessWidget {
//   const ShippingMethods({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Shipping Method',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             BlocBuilder<CheckoutBloc, CheckoutState>(
//               builder: (context, state) {
//                 return FutureBuilder<List<Map<String, dynamic>>>(
//                   future: context
//                       .read<CheckoutBloc>()
//                       .repository
//                       .getShippingMethods(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text(
//                           'Failed to load shipping methods',
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.error,
//                           ),
//                         ),
//                       );
//                     }

//                     final methods = snapshot.data ?? [];

//                     if (methods.isEmpty) {
//                       return const Center(
//                         child: Text('No shipping methods available'),
//                       );
//                     }

//                     return Column(
//                       children: methods.map((method) {
//                         return RadioListTile<String>(
//                           title: Text(method['title']),
//                           subtitle: Text(method['description']),
//                           value: method['id'],
//                           groupValue: state.shippingMethodId,
//                           onChanged: (value) {
//                             if (value != null) {
//                               context
//                                   .read<CheckoutBloc>()
//                                   .add(UpdateShippingMethod(value));
//                             }
//                           },
//                         );
//                       }).toList(),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
