import '../../domain/entities/order.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/order_item.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends OrderDetails {
  const OrderDetailsModel({
    required super.order,
    required super.items,
    super.customerNote,
    super.metadata,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json, Order order) {
    final List<OrderItem> items = (json['line_items'] as List?)
            ?.map(
                (item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    // Handle meta_data properly - it's a List<dynamic> not a Map
    final metaDataList = json['meta_data'] as List<dynamic>?;
    final Map<String, dynamic> metaDataMap = {};
    
    if (metaDataList != null) {
      for (var item in metaDataList) {
        if (item is Map<String, dynamic> && 
            item.containsKey('key') && 
            item.containsKey('value')) {
          metaDataMap[item['key'].toString()] = item['value'];
        }
      }
    }

    return OrderDetailsModel(
      order: order,
      items: items,
      customerNote: json['customer_note'] as String?,
      metadata: metaDataMap,
    );
  }

  OrderDetails toEntity() => this;
}
