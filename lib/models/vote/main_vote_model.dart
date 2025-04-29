import 'main_vote_artist_model.dart';

class MainVoteModel {
  final String voteCode;
  final String voteName;
  final String? voteImageURL;
  final int voteRestDay;
  final bool ongoing;
  final List<MainVoteArtistModel> topArtists;

  MainVoteModel({
    required this.voteCode,
    required this.voteName,
    this.voteImageURL,
    required this.voteRestDay,
    required this.ongoing,
    required this.topArtists,
  });

  factory MainVoteModel.fromJson(Map<String, dynamic> json) {
    return MainVoteModel(
      voteCode: json['voteCode'],
      voteName: json['voteName'],
      voteImageURL: json['voteImageURL'],
      voteRestDay: json['voteRestDay'],
      ongoing: json['ongoing'],
      topArtists: (json['topArtists'] as List)
          .map((artist) => MainVoteArtistModel.fromJson(artist))
          .toList(),
    );
  }
}
