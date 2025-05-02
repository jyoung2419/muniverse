// 필요 x 수정 예정

import 'package:flutter/material.dart';
import '../../models/vote/vote_reward_media_model.dart';
import '../../models/vote/vote_model.dart';

class VoteRewardMediaProvider with ChangeNotifier {
  final List<VoteRewardMediaModel> _media = [];

  List<VoteRewardMediaModel> get media => _media;

  List<String> get voteRewardMediaUrl =>
      _media.map((e) => e.voteRewardMediaUrl).toList();

  void fetchRewardMedia(List<VoteModel> votes) {
    _media.clear();

    final v001 = votes.firstWhere((v) => v.voteCode == 'V001');
    final v002 = votes.firstWhere((v) => v.voteCode == 'V002');
    final v003 = votes.firstWhere((v) => v.voteCode == 'V003');
    final v004 = votes.firstWhere((v) => v.voteCode == 'V004');
    final v005 = votes.firstWhere((v) => v.voteCode == 'V005');

    _media.addAll([
      // V001
      VoteRewardMediaModel(
        seq: 1,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '굿즈 패키지',
        vote: v001,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),
      VoteRewardMediaModel(
        seq: 2,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: 'V 라이브 초대권',
        vote: v001,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),

      // V002
      VoteRewardMediaModel(
        seq: 3,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '팬미팅 응모권',
        vote: v002,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),

      // V003
      VoteRewardMediaModel(
        seq: 4,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '뮤직비디오 제작 지원',
        vote: v003,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),

      // V004
      VoteRewardMediaModel(
        seq: 5,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '팬 감사 라이브 방송',
        vote: v004,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),

      // V005
      VoteRewardMediaModel(
        seq: 6,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '주간 베스트 뱃지',
        vote: v005,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),
      VoteRewardMediaModel(
        seq: 7,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '뮤직비디오 라이브 지원',
        vote: v003,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),
      VoteRewardMediaModel(
        seq: 8,
        voteRewardMediaUrl: 'assets/images/vote/reward.png',
        rewardContent: '뮤직비디오 라이브 지원',
        vote: v003,
        type: VoteRewardMediaType.IMAGE,
        createDate: DateTime.now(),
      ),
    ]);

    notifyListeners();
  }

  List<VoteRewardMediaModel> getMediaByVoteCode(String voteCode) {
    return _media.where((m) => m.vote.voteCode == voteCode).toList();
  }
}
