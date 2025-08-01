// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../bloc/checkout_bloc.dart';
// import '../../domain/entities/shipping_info.dart';
// import '../../../cart/presentation/bloc/cart_bloc.dart';
// import '../../../cart/domain/entities/cart_item.dart';
// import '../../../../core/utils/currency_formatter.dart';

// class ShippingAddressScreen extends StatefulWidget {
//   const ShippingAddressScreen({Key? key}) : super(key: key);

//   @override
//   State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
// }

// class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Load saved shipping info if not already loaded
//     context.read<CheckoutBloc>().add(LoadBillingInfo());
//     // Ensure cart is loaded
//     context.read<CartBloc>().add(LoadCart());
//   }

//   void _showAddressBottomSheet(BuildContext context, {bool isEdit = false}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => _AddressForm(
//         initialData:
//             isEdit ? context.read<CheckoutBloc>().state.shippingInfo : null,
//         onSave: (info) {
//           context.read<CheckoutBloc>().add(SaveShippingInfo(info));
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: BlocBuilder<CheckoutBloc, CheckoutState>(
//         builder: (context, state) {
//           if (state is CheckoutLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final hasAddress = state.shippingInfo != null &&
//               state.shippingInfo!.address.isNotEmpty &&
//               state.shippingInfo!.city.isNotEmpty;

//           return Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Shipping Address',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Show address card if address exists, otherwise show add button
//                       if (hasAddress)
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: ListTile(
//                             leading: const Icon(Icons.home_outlined),
//                             title: Text(
//                               '${state.shippingInfo!.address}, ${state.shippingInfo!.city}, ${state.shippingInfo!.state} ${state.shippingInfo!.zip}',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             subtitle: Text(
//                                 '${state.shippingInfo!.firstName} ${state.shippingInfo!.lastName}'),
//                             trailing: TextButton(
//                               onPressed: () => _showAddressBottomSheet(context,
//                                   isEdit: true),
//                               style: TextButton.styleFrom(
//                                 foregroundColor: Colors.deepPurple,
//                                 textStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               child: const Text('CHANGE'),
//                             ),
//                           ),
//                         )
//                       else
//                         Card(
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(12),
//                             onTap: () => _showAddressBottomSheet(context),
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 16, horizontal: 16),
//                               child: Text(
//                                 '+ Add New Shipping Address',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.deepPurple,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                       const SizedBox(height: 32),
//                       const Text(
//                         'Choose Shipping Type',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildShippingType(context, state),

//                       const SizedBox(height: 32),
//                       const Text(
//                         'Order List',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildOrderList(context, state),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: FilledButton(
//                     onPressed:
//                         hasAddress ? () => context.push('/payment') : null,
//                     style: FilledButton.styleFrom(
//                       backgroundColor: const Color(0xFF8B4513),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Continue to Payment',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildShippingType(BuildContext context, CheckoutState state) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.local_shipping_outlined, size: 20),
//         ),
//         title: const Text(
//           'Economy',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: const Text('Estimated Arrival 25 August 2023'),
//         trailing: TextButton(
//           onPressed: () {
//             // TODO: Show shipping methods selection
//           },
//           style: TextButton.styleFrom(
//             foregroundColor: Colors.deepPurple,
//             textStyle: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           child: const Text('CHANGE'),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderList(BuildContext context, CheckoutState state) {
//     return BlocBuilder<CartBloc, CartState>(
//       builder: (context, cartState) {
//         if (cartState is CartLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (cartState is CartError) {
//           return Center(
//               child: Text('Error loading cart: ${cartState.message}'));
//         }

//         if (cartState is CartLoaded) {
//           final items = cartState.items;

//           if (items.isEmpty) {
//             return const Center(child: Text('Your cart is empty'));
//           }

//           return Column(
//             children: [
//               ...items.map((item) => _buildOrderItem(item)).toList(),
//               const SizedBox(height: 16),
//               _buildOrderSummary(cartState),
//             ],
//           );
//         }

//         return const Center(child: Text('No items in cart'));
//       },
//     );
//   }

//   Widget _buildOrderItem(CartItem item) {
//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 item.imageUrl,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 60,
//                   height: 60,
//                   color: Colors.grey.shade300,
//                   child: const Icon(Icons.image, color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     'Size: ${item.selectedSize ?? 'XL'}',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               CurrencyFormatter.formatPrice(item.price),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummary(CartLoaded state) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildSummaryRow('Subtotal',
//                 CurrencyFormatter.formatPrice(state.subtotal.toString())),
//             _buildSummaryRow(
//                 'Tax', CurrencyFormatter.formatPrice(state.tax.toString())),
//             _buildSummaryRow('Shipping',
//                 CurrencyFormatter.formatPrice(state.shipping.toString())),
//             if (state.discount > 0)
//               _buildSummaryRow('Discount',
//                   '-${CurrencyFormatter.formatPrice(state.discount.toString())}'),
//             const Divider(),
//             _buildSummaryRow(
//               'Total',
//               CurrencyFormatter.formatPrice(state.total.toString()),
//               isTotal: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AddressForm extends StatefulWidget {
//   final ShippingInfo? initialData;
//   final void Function(ShippingInfo) onSave;

//   const _AddressForm({
//     this.initialData,
//     required this.onSave,
//   });

//   @override
//   State<_AddressForm> createState() => _AddressFormState();
// }

// class _AddressFormState extends State<_AddressForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _cityController;
//   late TextEditingController _stateController;
//   late TextEditingController _zipController;

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController =
//         TextEditingController(text: widget.initialData?.firstName ?? '');
//     _lastNameController =
//         TextEditingController(text: widget.initialData?.lastName ?? '');
//     _phoneController =
//         TextEditingController(text: widget.initialData?.phone ?? '');
//     _addressController =
//         TextEditingController(text: widget.initialData?.address ?? '');
//     _cityController =
//         TextEditingController(text: widget.initialData?.city ?? '');
//     _stateController =
//         TextEditingController(text: widget.initialData?.state ?? '');
//     _zipController = TextEditingController(text: widget.initialData?.zip ?? '');
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipController.dispose();
//     super.dispose();
//   }

//   void _save() {
//     if (_formKey.currentState!.validate()) {
//       widget.onSave(
//         ShippingInfo(
//           firstName: _firstNameController.text,
//           lastName: _lastNameController.text,
//           phone: _phoneController.text,
//           address: _addressController.text,
//           city: _cityController.text,
//           state: _stateController.text,
//           zip: _zipController.text,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Shipping Address',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _firstNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'First Name',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _lastNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Last Name',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Address',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   controller: _cityController,
//                   decoration: const InputDecoration(
//                     labelText: 'City',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (v) => v!.isEmpty ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _stateController,
//                         decoration: const InputDecoration(
//                           labelText: 'State/Province',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _zipController,
//                         decoration: const InputDecoration(
//                           labelText: 'ZIP/Postal Code',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (v) => v!.isEmpty ? 'Required' : null,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: FilledButton(
//                     onPressed: _save,
//                     child: const Text('Save Address'),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
