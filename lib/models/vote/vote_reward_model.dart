class VoteRewardModel {
  final String rewardContent;

  VoteRewardModel({required this.rewardContent});

  factory VoteRewardModel.fromJson(Map<String, dynamic> json) {
    return VoteRewardModel(
      rewardContent: json['rewardContent'] ?? '',
    );
  }
}
