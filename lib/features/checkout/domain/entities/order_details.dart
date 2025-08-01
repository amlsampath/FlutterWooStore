import 'package:equatable/equatable.dart';
import 'order.dart';
import 'order_item.dart';

class OrderDetails extends Equatable {
  final Order order;
  final List<OrderItem> items;
  final String? customerNote;
  final Map<String, dynamic>? metadata;

  const OrderDetails({
    required this.order,
    required this.items,
    this.customerNote,
    this.metadata,
  });

  @override
  List<Object?> get props => [order, items, customerNote, metadata];
}
