import 'package:dio/dio.dart';
import '../../models/order/order_request_model.dart';
import '../../utils/shared_prefs_util.dart';
import 'package:flutter/foundation.dart';

class OrderService {
  final Dio dio;

  OrderService(this.dio);

  Future<String?> requestPayment(OrderRequest request) async {
    final token = await SharedPrefsUtil.getAccessToken();
    if (token == null) throw Exception('❌ accessToken 없음');

    try {
      final formData = request.toFormData(); // 이미 key-value String Map
      final encoded = formData.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'); // x-www-form-urlencoded 형식으로 변환

      final response = await dio.post(
        '/api/v1/order/mobile/connection-payment',
        data: encoded,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data['next'];
    } catch (e) {
      if (e is DioException) {
        debugPrint('❌ Dio error data: ${e.response?.data}');
      } else {
        debugPrint('❌ Unknown error: $e');
      }
      rethrow;
    }
  }
}
