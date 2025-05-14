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

  RewardProvider(Dio dio, this._languageProvider)
      : _rewardService = RewardService(dio) {
    _languageProvider.addListener(() {
      fetchRewards();
    });
  }

  Future<void> fetchRewards() async {
    try {
      final rawList = await _rewardService.fetchRewardList();
      _rewards = rawList.map((e) => RewardItemModel.fromJson(e)).toList().reversed.toList();
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
