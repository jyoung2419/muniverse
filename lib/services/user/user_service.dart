import 'package:dio/dio.dart';
import '../../models/user/user_model.dart';
import '../../utils/dio_client.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  Future<UserModel> fetchCurrentUser() async {
    final response = await _dio.get('/api/v1/user/me');
    return UserModel.fromJson(response.data);
  }
}
