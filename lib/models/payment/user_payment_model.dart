class UserPaymentModel {
  final String orderId;
  final double totalOrderPrice;
  final String orderStatus;
  final String paymentType;
  final String? eventName;
  final DateTime createdAt;
  final List<OrderItemModel> orderItems;
  final List<UserPassModel> userPasses;

  UserPaymentModel({
    required this.orderId,
    required this.totalOrderPrice,
    required this.orderStatus,
    required this.paymentType,
    required this.createdAt,
    required this.orderItems,
    required this.userPasses,
    required this.eventName,
  });

  factory UserPaymentModel.fromJson(Map<String, dynamic> json) {
    return UserPaymentModel(
      orderId: json['orderId'],
      totalOrderPrice: (json['totalOrderPrice'] as num).toDouble(),
      orderStatus: json['orderStatus'],
      paymentType: json['paymentType'],
      createdAt: DateTime.parse(json['createdAt']),
      eventName: json['eventName'] as String?,
      orderItems: (json['orderItems'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      userPasses: (json['userPasses'] as List)
          .map((e) => UserPassModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'totalOrderPrice': totalOrderPrice,
    'orderStatus': orderStatus,
    'paymentType': paymentType,
    'createdAt': createdAt.toIso8601String(),
    'eventName': eventName,
    'orderItems': orderItems.map((e) => e.toJson()).toList(),
    'userPasses': userPasses.map((e) => e.toJson()).toList(),
  };
}

class OrderItemModel {
  final String productName;
  final String productImageUrl;
  final int amount;
  final double totalPriceForAmount;

  OrderItemModel({
    required this.productName,
    required this.productImageUrl,
    required this.amount,
    required this.totalPriceForAmount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productName: json['productName'],
      productImageUrl: json['productImageUrl'],
      amount: json['amount'],
      totalPriceForAmount: (json['totalPriceForAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'productImageUrl': productImageUrl,
    'amount': amount,
    'totalPriceForAmount': totalPriceForAmount,
  };
}

class UserPassModel {
  final String passName;
  final String regisPinNumber;
  final bool useFlag;
  final DateTime createdAt;
  final List<EventUseInfoModel> events;

  UserPassModel({
    required this.passName,
    required this.regisPinNumber,
    required this.useFlag,
    required this.createdAt,
    required this.events,
  });

  factory UserPassModel.fromJson(Map<String, dynamic> json) {
    return UserPassModel(
      passName: json['passName'],
      regisPinNumber: json['regisPinNumber'],
      useFlag: json['useFlag'],
      createdAt: DateTime.parse(json['createdAt']),
      events: (json['events'] as List)
          .map((e) => EventUseInfoModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'passName': passName,
    'regisPinNumber': regisPinNumber,
    'useFlag': useFlag,
    'createdAt': createdAt.toIso8601String(),
    'events': events.map((e) => e.toJson()).toList(),
  };
}

class EventUseInfoModel {
  final String code;
  final String type;
  final String pinNumber;
  final bool used;
  final DateTime? usedAt;

  EventUseInfoModel({
    required this.code,
    required this.type,
    required this.pinNumber,
    required this.used,
    this.usedAt,
  });

  factory EventUseInfoModel.fromJson(Map<String, dynamic> json) {
    return EventUseInfoModel(
      code: json['code'],
      type: json['type'],
      pinNumber: json['pinNumber'],
      used: json['used'],
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'type': type,
    'pinNumber': pinNumber,
    'used': used,
    'usedAt': usedAt?.toIso8601String(),
  };
}
