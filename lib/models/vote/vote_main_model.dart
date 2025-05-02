enum VoteStatus { BE_OPEN, OPEN, CLOSED, WAITING }

class VoteRewardModel {
  final String rewardContent;

  VoteRewardModel({required this.rewardContent});

  factory VoteRewardModel.fromJson(Map<String, dynamic> json) {
    return VoteRewardModel(
      rewardContent: json['rewardContent'] ?? '',
    );
  }
}

class VoteMainModel {
  final String voteCode;
  final String voteName;
  final String content;
  final DateTime startTime;
  final DateTime endTime;
  final VoteStatus voteStatus;
  final int voteRestDay;
  final String? voteImageURL;
  final List<VoteRewardModel> rewards;

  VoteMainModel({
    required this.voteCode,
    required this.voteName,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.voteStatus,
    required this.voteRestDay,
    required this.voteImageURL,
    required this.rewards,
  });

  factory VoteMainModel.fromJson(Map<String, dynamic> json) {
    return VoteMainModel(
      voteCode: json['voteCode'] ?? '',
      voteName: json['voteName'] ?? '',
      content: json['content'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      voteStatus: VoteStatus.values.firstWhere(
            (e) => e.name == json['voteStatus'],
        orElse: () => VoteStatus.WAITING,
      ),
      voteRestDay: json['voteRestDay'] ?? 0,
      voteImageURL: json['voteImageURL'],
      rewards: (json['rewards'] as List<dynamic>?)?.map((e) => VoteRewardModel.fromJson(e)).toList() ?? [],
    );
  }
}