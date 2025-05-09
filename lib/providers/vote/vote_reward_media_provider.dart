import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/vote/vote_reward_media_model.dart';
import '../../services/vote/vote_service.dart';

class VoteRewardMediaProvider with ChangeNotifier {
  List<VoteRewardMediaModel> _mediaList = [];

  List<VoteRewardMediaModel> get mediaList => _mediaList;

  final VoteService _voteService;
  VoteRewardMediaProvider(Dio dio) : _voteService = VoteService(dio);

  Future<void> fetchVoteRewardMedia(String voteCode) async {
    try {
      final response = await _voteService.getVoteRewardMedia(voteCode);
      _mediaList = response.map((e) => VoteRewardMediaModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('❌ VoteRewardMediaProvider fetch 실패: $e');
      _mediaList = [];
      notifyListeners();
    }
  }

  void clear() {
    _mediaList = [];
    notifyListeners();
  }
}
