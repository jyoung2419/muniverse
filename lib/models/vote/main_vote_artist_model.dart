class MainVoteArtistModel {
  final String artistCode;
  final String name;
  final String profileUrl;
  final int voteCount;
  final double votePercent;

  MainVoteArtistModel({
    required this.artistCode,
    required this.name,
    required this.profileUrl,
    required this.voteCount,
    required this.votePercent,
  });

  factory MainVoteArtistModel.fromJson(Map<String, dynamic> json) {
    return MainVoteArtistModel(
      artistCode: json['artistCode'],
      name: json['name'],
      profileUrl: json['profileUrl'],
      voteCount: json['voteCount'],
      votePercent: (json['votePercent'] as num).toDouble(),
    );
  }
}
