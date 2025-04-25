import 'package:flutter/material.dart';
import '../../models/event/event_live_model.dart';
import '../../models/event/event_model.dart';

class EventLiveProvider with ChangeNotifier {
  List<EventLiveModel> _streamings = [];

  List<EventLiveModel> get streamings => _streamings;

  EventLiveProvider() {
    fetchDummyStreamings();
  }

  void fetchDummyStreamings() {
    _streamings = [
      EventLiveModel(
        liveCode: 'stream-001',
        name: 'BIG 콘서트',
        content: '생생한 무대 실황',
        profileImageUrl: 'assets/images/live.png',
        videoUrl: 'https://example.com/video1.mp4',
        taskDate: DateTime(2025, 4, 11, 18, 0),
        taskEndDate: DateTime(2025, 4, 14, 20, 0),
        eventYear: 2025,
        round: 1,
        eventCode: 'E001',
        createDate: DateTime(2025, 6, 11),
        updateDate: null,
        event: EventModel(
          eventCode: 'E001',
          name: 'BIG 콘서트',
          content: 'BIG 콘서트 현장 스트리밍',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/mokpo_banner.png',
          profileUrl: 'assets/images/event_description_bof.png',

          shortName: 'BIG콘',

          performanceStartTime: DateTime(2025, 6, 11, 18, 0),
          performanceEndTime: DateTime(2025, 6, 11, 20, 0),

        ),
      ),
    ];

    notifyListeners();
  }

  void clear() {
    _streamings = [];
    notifyListeners();
  }
}
