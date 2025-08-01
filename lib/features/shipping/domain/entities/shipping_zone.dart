class ShippingZone {
  final int id;
  final String name;
  final int order;
  final List<ShippingMethod> methods;
  final List<Map<String, dynamic>> locations;

  const ShippingZone({
    required this.id,
    required this.name,
    required this.order,
    this.methods = const [],
    this.locations = const [],
  });

  factory ShippingZone.fromJson(Map<String, dynamic> json) {
    return ShippingZone(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
      methods: const [],
    );
  }
}

class ShippingMethod {
  final int id;
  final String methodId;
  final String title;
  final bool enabled;
  final String? description;
  final String? cost;
  final int? minimumOrderAmount;
  final Map<String, dynamic> settings;

  const ShippingMethod({
    required this.id,
    required this.methodId,
    required this.title,
    required this.enabled,
    this.description,
    this.cost,
    this.minimumOrderAmount,
    this.settings = const {},
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    final settings = json['settings'] as Map<String, dynamic>? ?? {};
    final costSettings = settings['cost'] as Map<String, dynamic>? ?? {};
    final minAmountSettings =
        settings['min_amount'] as Map<String, dynamic>? ?? {};
    final descriptionSettings =
        settings['description'] as Map<String, dynamic>? ?? {};

    return ShippingMethod(
      id: json['id'] as int? ?? 0,
      methodId: json['method_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      description: descriptionSettings['value'] as String?,
      cost: costSettings['value'] as String?,
      minimumOrderAmount:
          int.tryParse(minAmountSettings['value'] as String? ?? '0'),
      settings: settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'description': description ?? '',
      'cost': cost ?? '0',
    };
  }
}
