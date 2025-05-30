import 'package:flutter/material.dart';
import '../../models/order/order_request_model.dart';
import '../../services/order/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService service;

  OrderProvider(this.service);

  Future<String?> createPayment(OrderRequest request) async {
    return await service.requestPayment(request);
  }
}
