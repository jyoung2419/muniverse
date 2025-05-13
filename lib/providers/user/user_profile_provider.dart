import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/user/user_profile_model.dart';
import '../../services/user/user_profile_service.dart';

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _userProfileService;
  UserProfileModel? _userProfileModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfileProvider(Dio dio) : _userProfileService = UserProfileService(dio);

  UserProfileModel? get user => _userProfileModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserDetail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _userProfileService.getUserDetail();
      _userProfileModel = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? nickname,
    String? name,
    bool? localFlag,
    String? profileImagePath,
  }) async {
    try {
      await _userProfileService.patchUserProfile(
        userId: userId,
        nickName: nickname,
        name: name,
        localFlag: localFlag,
        profileImagePath: profileImagePath,
      );
      await fetchUserDetail();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clear() {
    _userProfileModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}
