// 사용x
import 'vote_model.dart';

enum VoteRewardMediaType { IMAGE, VIDEO }

VoteRewardMediaType voteRewardMediaTypeFromString(String type) {
  return VoteRewardMediaType.values.firstWhere((e) => e.name == type);
}

class VoteRewardMediaModel {
  final int seq;
  final String voteRewardMediaUrl;
  final String rewardContent;
  final VoteModel vote;
  final VoteRewardMediaType type;
  final DateTime createDate;

  VoteRewardMediaModel({
    required this.seq,
    required this.voteRewardMediaUrl,
    required this.rewardContent,
    required this.vote,
    required this.type,
    required this.createDate,
  });

  factory VoteRewardMediaModel.fromJson(Map<String, dynamic> json) {
    return VoteRewardMediaModel(
      seq: json['seq'],
      voteRewardMediaUrl: json['voteRewardMediaUrl'],
      rewardContent: json['rewardContent'],
      vote: VoteModel.fromJson(json['vote']),
      type: voteRewardMediaTypeFromString(json['type']),
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'voteRewardMediaUrl': voteRewardMediaUrl,
      'rewardContent': rewardContent,
      'vote': vote.toJson(),
      'type': type.name,
      'createDate': createDate.toIso8601String(),
    };
  }
}
