enum VoteRewardMediaType { IMAGE, VIDEO }

class VoteRewardMediaModel {
  final String voteRewardMediaURL;
  final String rewordContent;
  final VoteRewardMediaType type;

  VoteRewardMediaModel({
    required this.voteRewardMediaURL,
    required this.rewordContent,
    required this.type,
  });

  factory VoteRewardMediaModel.fromJson(Map<String, dynamic> json) {
    return VoteRewardMediaModel(
      voteRewardMediaURL: json['voteRewardMediaURL'] ?? '',
      rewordContent: json['rewordContent'] ?? '',
      type: VoteRewardMediaType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => VoteRewardMediaType.IMAGE,
      ),
    );
  }
}
