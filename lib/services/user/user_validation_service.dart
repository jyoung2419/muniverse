import 'package:dio/dio.dart';
import '../../utils/dio_client.dart';

class UserValidationService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> checkNickname(String nickname) async {
    final response = await _dio.post(
      '/api/v1/user/oauth/validation/nickname',
      data: {'nickName': nickname},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> checkEmail(String email) async {
    final response = await _dio.post(
      '/api/v1/user/oauth/validation/email',
      data: {'email': email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> checkId(String id) async {
    final response = await _dio.post(
      '/api/v1/user/oauth/validation/id',
      data: {'id': id},
    );
    return response.data;
  }
}