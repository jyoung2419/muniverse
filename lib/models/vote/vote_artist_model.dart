// 사용x
import '../artist/artist_model.dart';
import 'vote_model.dart';

class VoteArtistModel {
  final int seq;
  final int voteCount;
  final ArtistModel artist;
  final VoteModel vote;
  final DateTime createDate;

  const VoteArtistModel({
    required this.seq,
    required this.voteCount,
    required this.artist,
    required this.vote,
    required this.createDate,
  });

  factory VoteArtistModel.fromJson(Map<String, dynamic> json) {
    return VoteArtistModel(
      seq: json['seq'],
      voteCount: json['voteCount'],
      artist: ArtistModel.fromJson(json['artist']),
      vote: VoteModel.fromJson(json['vote']),
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'voteCount': voteCount,
      'artist': artist.toJson(),
      'vote': vote.toJson(),
      'createDate': createDate.toIso8601String(),
    };
  }
}
