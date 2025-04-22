import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/user/user_model.dart';
import '../../services/user/dio_client.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> fetchCurrentUser() async {
    try {
      final dio = DioClient().dio;
      final response = await dio.get('/api/v1/user/me');
      final data = response.data;
      _currentUser = UserModel.fromJson(data);
      notifyListeners();
    } catch (e) {
      debugPrint('🚨 사용자 정보 불러오기 실패: \$e');
    }
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}