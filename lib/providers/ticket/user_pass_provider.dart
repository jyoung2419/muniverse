import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/ticket/user_pass_model.dart';
import '../../services/ticket/user_pass_service.dart';
import '../language_provider.dart';

class UserPassProvider with ChangeNotifier {
  final UserPassService _userPassService;
  final LanguageProvider _languageProvider;

  UserPassProvider(Dio dio, this._languageProvider)
      : _userPassService = UserPassService(dio) {
    _languageProvider.addListener(() {
      fetchUserPasses();
    });
  }

  List<UserPassModel> _userPasses = [];
  List<UserPassModel> get userPasses => _userPasses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserPasses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userPasses = await _userPassService.fetchMyUserPasses();
    } catch (e) {
      _userPasses = [];
      print('❌ 이용권 목록 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPasses() {
    _userPasses = [];
    notifyListeners();
  }

  Future<void> registerUserPass(String pinNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userPassService.registerUserPass(pinNumber);
      await fetchUserPasses();
    } catch (e) {
      print('❌ 등록 실패: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
