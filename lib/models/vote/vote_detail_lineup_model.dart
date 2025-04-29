class VoteDetailLineUpModel {
  final String artistProfileImageUrl;
  final String artistName;
  final String? voteArtistSeq;
  final double votePercent;

  VoteDetailLineUpModel({
    required this.artistProfileImageUrl,
    required this.artistName,
    this.voteArtistSeq,
    required this.votePercent,
  });

  factory VoteDetailLineUpModel.fromJson(Map<String, dynamic> json) {
    return VoteDetailLineUpModel(
      artistProfileImageUrl: json['artistProfileImageUrl'],
      artistName: json['artistName'],
      voteArtistSeq: json['voteArtistSeq'],
      votePercent: (json['votePercent'] as num).toDouble(),
    );
  }
}
