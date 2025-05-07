import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/user_model.dart';
import '../../utils/dio_client.dart';
import '../../utils/shared_prefs_util.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  Future<void> logout() async {
    try {
      final accessToken = await SharedPrefsUtil.getAccessToken();
      final deviceId = await SharedPrefsUtil.getOrCreateDeviceId();

      await _dio.post(
        '/api/v1/user/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-Device-Id': deviceId,
            'User-Agent': 'MuniverseApp/iOS',
          },
        ),
      );
    } catch (_) {
      // 무시
    }

    await SharedPrefsUtil.clear();
  }
}
