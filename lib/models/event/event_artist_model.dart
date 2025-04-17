import '../artist_model.dart';
import 'event_model.dart';

class EventArtistModel {
  final int seq;
  final EventModel event;
  final ArtistModel artist;
  final DateTime createDate;

  const EventArtistModel({
    required this.seq,
    required this.event,
    required this.artist,
    required this.createDate,
  });

  factory EventArtistModel.fromJson(Map<String, dynamic> json) {
    return EventArtistModel(
      seq: json['seq'],
      event: EventModel.fromJson(json['event']),
      artist: ArtistModel.fromJson(json['artist']),
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'event': event.toJson(),
      'artist': artist.toJson(),
      'createDate': createDate.toIso8601String(),
    };
  }
}
