import 'package:dio/dio.dart';
import '../../models/user/user_me_model.dart';
import '../../utils/dio_client.dart';

class UserMeService {
  final Dio _dio = DioClient().dio;

  Future<UserMeModel> getUserMe() async {
    try {
      final response = await _dio.get('/api/v1/user/me');
      print('🔥 /me 응답 데이터: ${response.data}');
      if (response.statusCode == 200) {
        return UserMeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user info: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.statusCode ?? ''} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
