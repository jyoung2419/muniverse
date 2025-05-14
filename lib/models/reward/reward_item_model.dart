enum RewardStatus {
  REGISTERED,      // 등록
  DRAWN,           // 추첨완료
  COLLECTING_INFO, // 정보기입중
  INFORMED,        // 이메일 발송완료상태
  CLOSED           // 종료
}

class RewardItemModel {
  final String rewardCode;
  final String voteProfileImageURL;
  final String voteName;
  final DateTime voteOpenDate;
  final DateTime voteCloseDate;
  final String status;

  RewardItemModel({
    required this.rewardCode,
    required this.voteProfileImageURL,
    required this.voteName,
    required this.voteOpenDate,
    required this.voteCloseDate,
    required this.status,
  });

  factory RewardItemModel.fromJson(Map<String, dynamic> json) {
    return RewardItemModel(
      rewardCode: json['rewardCode'] ?? '',
      voteProfileImageURL: json['voteProfileImageURL'] ?? '',
      voteName: json['voteName'] ?? '',
      voteOpenDate: _parseDate(json['voteOpenDate']) ?? DateTime(2000, 1, 1),
      voteCloseDate: _parseDate(json['voteCloseDate']) ?? DateTime(2000, 1, 1),
      status: json['status'] ?? 'UNKNOWN',
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  RewardStatus get rewardStatusEnum => RewardStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == status.toUpperCase(),
    orElse: () => RewardStatus.CLOSED,
  );
}
