import '../artist/artist_model.dart';
import 'event_model.dart';

class EventArtistModel {
  final int seq;
  final ArtistModel artist;
  final DateTime createDate;

  const EventArtistModel({
    required this.seq,
    required this.artist,
    required this.createDate,
  });

  factory EventArtistModel.fromJson(Map<String, dynamic> json) {
    return EventArtistModel(
      seq: json['seq'],
      artist: ArtistModel.fromJson(json['artist']),
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'artist': artist.toJson(),
      'createDate': createDate.toIso8601String(),
    };
  }
}
