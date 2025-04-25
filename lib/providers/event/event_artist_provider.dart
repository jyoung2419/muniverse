import 'package:flutter/material.dart';
import '../../models/event/event_artist_model.dart';
import '../../models/event/event_model.dart';
import '../../models/artist/artist_model.dart';

class EventArtistProvider with ChangeNotifier {
  final List<EventArtistModel> _eventArtists = [];

  List<EventArtistModel> get eventArtists => _eventArtists;

  void fetchEventArtists({
    required List<EventModel> events,
    required List<ArtistModel> artists,
  }) {
    _eventArtists.clear();

    final mokpo = events.firstWhere((e) => e.eventCode == 'E001'); // 목포
    final bof = events.firstWhere((e) => e.eventCode == 'E002'); // 부산

    _eventArtists.addAll([
      EventArtistModel(
        seq: 1,
        artist: artists.firstWhere((a) => a.artistCode == 'A001'), // 르세라핌
        createDate: DateTime(2025, 7, 1),
      ),
      EventArtistModel(
        seq: 2,
        artist: artists.firstWhere((a) => a.artistCode == 'A002'), // 더킹덤
        createDate: DateTime(2025, 8, 20),
      ),
    ]);

    notifyListeners();
  }

}
