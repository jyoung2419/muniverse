import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/reward/reward_item_model.dart';
import '../../models/reward/reward_user_info_model.dart';
import '../../services/reward/reward_service.dart';
import '../language_provider.dart';

class RewardProvider with ChangeNotifier {
  final RewardService _rewardService;
  final LanguageProvider _languageProvider;

  List<RewardItemModel> _rewards = [];
  List<RewardItemModel> get rewards => _rewards;

  int _currentPage = 0;
  bool _lastPage = false;
  bool get hasMore => !_lastPage;

  RewardProvider(Dio dio, this._languageProvider)
      : _rewardService = RewardService(dio) {
    _languageProvider.addListener(() {
      resetAndFetchRewards();
    });
  }

  Future<void> resetAndFetchRewards() async {
    _currentPage = 0;
    _lastPage = false;
    _rewards.clear();
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (_lastPage) return;
    try {
      final response = await _rewardService.fetchRewardList(page: _currentPage, size: 10);
      _rewards.addAll(response.content);
      _lastPage = response.last;
      _currentPage += 1;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to fetch rewards: $e');
    }
  }

  Future<Map<String, dynamic>> fetchRewardCheck(String rewardCode) async {
    return await _rewardService.fetchRewardCheck(rewardCode);
  }

  Future<Map<String, dynamic>> fetchRewardUserInfo(String rewardCode) async {
    return await _rewardService.fetchRewardUserInfo(rewardCode);
  }

  Future<void> submitRewardUserInfo(RewardUserInfoModel model) async {
    await _rewardService.submitRewardUserInfo(model);
  }
}