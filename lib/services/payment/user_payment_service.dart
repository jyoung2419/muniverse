import 'package:dio/dio.dart';
import '../../utils/shared_prefs_util.dart';

class UserPaymentService {
  final Dio _dio;

  UserPaymentService(this._dio);

  Future<List<dynamic>> fetchPayments({int page = 0, int size = 10, String sort = 'createdAt,desc'}) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/user/payment',
        queryParameters: {
          'page': page,
          'size': size,
          'sort': sort,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data is Map && response.data['content'] is List) {
        return response.data['content'] as List;
      }

      throw Exception('Unexpected payment response format');
    } catch (e) {
      if (e is DioException) {
        print('❌ Dio error data: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
