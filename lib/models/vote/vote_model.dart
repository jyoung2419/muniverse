class VoteModel {
  final String voteCode;
  final String voteName;
  final String content;
  final String voteImageUrl;
  final int freeCountLimit;
  final String eventCode; // event 객체가 아닌 식별자만
  final String rewardContent;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime resultOpenTime;
  final DateTime createDate;
  final DateTime? updateDate;
  final bool deleteFlag;

  const VoteModel({
    required this.voteCode,
    required this.voteName,
    required this.content,
    required this.voteImageUrl,
    required this.freeCountLimit,
    required this.eventCode,
    required this.rewardContent,
    required this.startTime,
    required this.endTime,
    required this.resultOpenTime,
    required this.createDate,
    this.updateDate,
    required this.deleteFlag,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      voteCode: json['voteCode'],
      voteName: json['voteName'],
      content: json['content'],
      voteImageUrl: json['voteImageUrl'],
      freeCountLimit: json['freeCountLimit'],
      eventCode: json['eventCode'], // nested event 대신 ID만 받는다고 가정
      rewardContent: json['rewardContent'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      resultOpenTime: DateTime.parse(json['resultOpenTime']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      deleteFlag: json['deleteFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voteCode': voteCode,
      'voteName': voteName,
      'content': content,
      'voteImageUrl': voteImageUrl,
      'freeCountLimit': freeCountLimit,
      'eventCode': eventCode,
      'rewardContent': rewardContent,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'resultOpenTime': resultOpenTime.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'deleteFlag': deleteFlag,
    };
  }
}
