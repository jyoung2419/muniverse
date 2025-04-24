import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/user_model.dart';
import '../../utils/dio_client.dart';
import '../../utils/shared_prefs_util.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  Future<UserModel> fetchCurrentUser() async {
    final response = await _dio.get('/api/v1/user/me');
    return UserModel.fromJson(response.data);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/v1/user/logout');
    } catch (_) {
      // 무시
    }

    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(storage: FileStorage("${dir.path}/.cookies/"));
    await cookieJar.deleteAll();
    await SharedPrefsUtil.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
