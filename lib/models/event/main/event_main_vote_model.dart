import 'event_main_vote_artist_model.dart';

class EventMainVoteModel {
  final String voteCode;
  final String voteName;
  final String? voteImageURL;
  final int voteRestDay;
  final bool ongoing;
  final List<EventMainVoteArtistModel> topArtists;

  EventMainVoteModel({
    required this.voteCode,
    required this.voteName,
    this.voteImageURL,
    required this.voteRestDay,
    required this.ongoing,
    required this.topArtists,
  });

  factory EventMainVoteModel.fromJson(Map<String, dynamic> json) {
    return EventMainVoteModel(
      voteCode: json['voteCode'],
      voteName: json['voteName'],
      voteImageURL: json['voteImageURL'],
      voteRestDay: json['voteRestDay'],
      ongoing: json['ongoing'],
      topArtists: (json['topArtists'] as List)
          .map((artist) => EventMainVoteArtistModel.fromJson(artist))
          .toList(),
    );
  }
}
