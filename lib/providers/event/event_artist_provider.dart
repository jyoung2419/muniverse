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
        event: mokpo,
        artist: artists.firstWhere((a) => a.artistCode == 'A001'), // 르세라핌
        createDate: DateTime(2025, 7, 1),
      ),
      EventArtistModel(
        seq: 2,
        event: bof,
        artist: artists.firstWhere((a) => a.artistCode == 'A002'), // 더킹덤
        createDate: DateTime(2025, 8, 20),
      ),
      EventArtistModel(
        seq: 3,
        event: bof,
        artist: artists.firstWhere((a) => a.artistCode == 'A003'), // 캣츠아이
        createDate: DateTime(2025, 8, 20),
      ),
      EventArtistModel(
        seq: 4,
        event: mokpo,
        artist: artists.firstWhere((a) => a.artistCode == 'A004'), // 베이비몬스터
        createDate: DateTime(2025, 7, 1),
      ),
      EventArtistModel(
        seq: 5,
        event: bof,
        artist: artists.firstWhere((a) => a.artistCode == 'A005'), // QWER
        createDate: DateTime(2025, 8, 20),
      ),
    ]);

    notifyListeners();
  }

  List<EventArtistModel> getArtistsByEventCode(String eventCode) {
    return _eventArtists.where((ea) => ea.event.eventCode == eventCode).toList();
  }

  List<EventModel> getEventsByArtistCode(String artistCode) {
    return _eventArtists
        .where((ea) => ea.artist.artistCode == artistCode)
        .map((ea) => ea.event)
        .toList();
  }
}
