enum VoteStatus { BE_OPEN, OPEN, CLOSED, WAITING }

class VoteDetailContentModel {
  final String voteImageUrl;
  final String voteStatus;
  final int voteRestDay;
  final String voteName;
  final DateTime startTime;
  final DateTime endTime;
  final String content;

  VoteDetailContentModel({
    required this.voteImageUrl,
    required this.voteStatus,
    required this.voteRestDay,
    required this.voteName,
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  factory VoteDetailContentModel.fromJson(Map<String, dynamic> json) {
    return VoteDetailContentModel(
      voteImageUrl: json['voteImageURL'],
      voteStatus: json['voteStatus'],
      voteRestDay: json['voteRestDay'],
      voteName: json['voteName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      content: json['content'],
    );
  }

  VoteStatus get voteStatusEnum => VoteStatus.values.firstWhere(
        (e) => e.name == voteStatus,
    orElse: () => VoteStatus.WAITING,
  );
}
