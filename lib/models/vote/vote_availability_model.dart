class VoteAvailabilityModel {
  final String voteCode;
  final int usedCount;
  final int remainingCount;
  final bool canVote;

  VoteAvailabilityModel({
    required this.voteCode,
    required this.usedCount,
    required this.remainingCount,
    required this.canVote,
  });

  factory VoteAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return VoteAvailabilityModel(
      voteCode: json['voteCode'] ?? '',
      usedCount: json['usedCount'] ?? 0,
      remainingCount: json['remainingCount'] ?? 0,
      canVote: json['canVote'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voteCode': voteCode,
      'usedCount': usedCount,
      'remainingCount': remainingCount,
      'canVote': canVote,
    };
  }
}
