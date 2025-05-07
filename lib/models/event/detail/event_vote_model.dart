class EventVoteModel {
  final String voteCode;
  final String voteName;
  final String voteImageUrl;
  final String voteStatus; // 서버는 enum (BE_OPEN, OPEN, CLOSED)인데, 문자열로 받음
  final int voteRestDay;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> rewards;

  EventVoteModel({
    required this.voteCode,
    required this.voteName,
    required this.voteImageUrl,
    required this.voteStatus,
    required this.voteRestDay,
    required this.startTime,
    required this.endTime,
    required this.rewards,
  });

  factory EventVoteModel.fromJson(Map<String, dynamic> json) {
    return EventVoteModel(
      voteCode: json['voteCode']?.toString() ?? '',
      voteName: json['voteName']?.toString() ?? '',
      voteImageUrl: json['voteImageURL']?.toString() ?? '',
      voteStatus: json['voteStatus']?.toString() ?? '',
      voteRestDay: json['voteRestDay'] ?? 0,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      rewards: (json['rewards'] as List<dynamic>)
          .map((reward) => reward['rewardContent']?.toString() ?? '')
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'voteCode': voteCode,
      'voteName': voteName,
      'voteImageURL': voteImageUrl,
      'voteStatus': voteStatus,
      'voteRestDay': voteRestDay,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'rewards': rewards,
    };
  }
}
