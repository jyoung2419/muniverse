import 'package:flutter/material.dart';
import '../../models/user/user_model.dart';
import '../../services/user/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}