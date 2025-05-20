import 'package:dio/dio.dart';
import '../../utils/shared_prefs_util.dart';

class UserPaymentService {
  final Dio _dio;

  UserPaymentService(this._dio);

  Future<List<dynamic>> fetchPayments() async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/user/payment',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data as List;
    } catch (e) {
      if (e is DioException) {
        print('❌ Dio error data: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
