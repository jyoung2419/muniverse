import 'order_item_model.dart';

class OrderRequest {
  final List<OrderItem> items;
  final String paymentType;
  final String phoneNumber;
  final String payLanguage;
  final String email;
  final String orderedName;

  OrderRequest({
    required this.items,
    required this.paymentType,
    required this.phoneNumber,
    required this.payLanguage,
    required this.email,
    required this.orderedName,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'paymentType': paymentType,
      'phoneNumber': phoneNumber,
      'payLanguage': payLanguage,
      'email': email,
      'orderedName': orderedName,
    };
  }
}
extension OrderRequestExtension on OrderRequest {
  Map<String, String> toFormData() {
    final Map<String, String> data = {
      'orderedName': orderedName,
      'email': email,
      'phoneNumber': phoneNumber,
      'paymentType': paymentType,
      'payLanguage': payLanguage,
    };

    for (int i = 0; i < items.length; i++) {
      data['items[$i].viewType'] = items[i].viewType;
      data['items[$i].productCode'] = items[i].productCode;
      data['items[$i].amount'] = items[i].amount.toString();
    }

    return data;
  }
}