import 'package:flutter/material.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<void> fetchCurrentUser() async {
    try {
      _currentUser = await _userService.fetchCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('🚨 사용자 정보 불러오기 실패: $e');
    }
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}