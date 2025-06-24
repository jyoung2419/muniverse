import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order/order_request_model.dart';
import '../../services/order/order_service.dart';
import '../../utils/dio_client.dart';

final orderProvider = Provider<OrderNotifier>((ref) {
  final dio = ref.watch(dioProvider);
  final service = OrderService(dio);
  return OrderNotifier(service);
});

class OrderNotifier {
  final OrderService service;

  OrderNotifier(this.service);

  Future<String?> createPayment(OrderRequest request) async {
    return await service.requestPayment(request);
  }
}
