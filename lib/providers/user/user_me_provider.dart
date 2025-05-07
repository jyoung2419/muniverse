import 'package:flutter/material.dart';
import '../../models/user/user_me_model.dart';
import '../../services/user/user_me_service.dart';

class UserMeProvider with ChangeNotifier {
  UserMeModel? _userMe;
  bool _isLoading = false;
  String? _errorMessage;

  UserMeModel? get userMe => _userMe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserMe() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = await UserMeService().getUserMe();
      _userMe = userData;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
