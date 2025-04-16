class VoteModel {
  final String topic; // 예: '최고 인기 여자 아이돌'
  final String artistName; // 예: 'LESSERAFIM'
  final String artistNameKr; // 예: '르세라핌'
  final String imageUrl;
  final double voteRate; // 예: 56.0
  final int totalVotes; // 예: 40442
  final String round;       // 🔥 추가: '1일차' 등
  final String status;      // 🔥 추가: '진행 중'
  final String dateRange;   // 🔥 추가: '2025.03.31 ~ 2025.04.06'

  VoteModel({
    required this.topic,
    required this.artistName,
    required this.artistNameKr,
    required this.imageUrl,
    required this.voteRate,
    required this.totalVotes,
    required this.round,
    required this.status,
    required this.dateRange,
  });
}
