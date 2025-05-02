import 'package:muniverse_app/models/vote/vote_reward_model.dart';

import '../event/detail/event_vote_model.dart';
import 'vote_detail_content_model.dart';
import 'vote_detail_lineup_model.dart';

class VoteDetailModel {
  final int totalArtistCount;
  final bool voteActive;
  final VoteDetailContentModel detailContent;
  final List<VoteDetailLineUpModel> lineUp;
  final List<VoteRewardModel> rewards;

  VoteDetailModel({
    required this.totalArtistCount,
    required this.voteActive,
    required this.detailContent,
    required this.lineUp,
    required this.rewards,
  });

  factory VoteDetailModel.fromJson(Map<String, dynamic> json) {
    return VoteDetailModel(
      totalArtistCount: json['totalArtistCount'],
      voteActive: json['voteActive'],
      detailContent: VoteDetailContentModel.fromJson(json['detailContent']),
      lineUp: (json['lineUp'] as List)
          .map((e) => VoteDetailLineUpModel.fromJson(e))
          .toList(),
      rewards: (json['rewards'] as List<dynamic>?)
          ?.map((e) => VoteRewardModel(rewardContent: e.toString()))
          .toList() ?? [],
    );
  }
}
