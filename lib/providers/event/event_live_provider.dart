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
        taskDate: DateTime(2025, 6, 11, 18, 0),
        taskEndDate: DateTime(2025, 6, 11, 20, 0),
        eventYear: 2025,
        event: EventModel(
          eventCode: 'E001',
          name: 'BIG 콘서트',
          content: 'BIG 콘서트 현장 스트리밍',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/banner_mokpo.png',
          profileUrl: 'assets/images/event_description_bof.png',
          preOpenDateTime: DateTime(2025, 6, 1),
          openDateTime: DateTime(2025, 6, 10),
          endDateTime: DateTime(2025, 6, 15),
          performanceStartTime: DateTime(2025, 6, 11, 18, 0),
          performanceEndTime: DateTime(2025, 6, 11, 20, 0),
          activeFlag: true,
          createDate: DateTime(2025, 5, 1),
          updateDate: null,
          deleteFlag: false,
          artists: [],
        ),
        createDate: DateTime(2025, 6, 11),
        updateDate: null,
      ),
      EventLiveModel(
        liveCode: 'stream-002',
        name: 'K-POP 밴드 콘서트',
        content: '밴드의 열정 가득한 무대',
        profileImageUrl: 'assets/images/live.png',
        videoUrl: 'https://example.com/video2.mp4',
        taskDate: DateTime(2025, 6, 12, 18, 0),
        taskEndDate: DateTime(2025, 6, 12, 21, 0),
        eventYear: 2025,
        event: EventModel(
          eventCode: 'E002',
          name: 'K-POP 밴드 콘서트',
          content: 'K-POP 밴드 콘서트 스트리밍',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/banner_mokpo.png',
          profileUrl: 'assets/images/event_description_bof.png',
          preOpenDateTime: DateTime(2025, 6, 2),
          openDateTime: DateTime(2025, 6, 11),
          endDateTime: DateTime(2025, 6, 16),
          performanceStartTime: DateTime(2025, 6, 12, 18, 0),
          performanceEndTime: DateTime(2025, 6, 12, 21, 0),
          activeFlag: true,
          createDate: DateTime(2025, 5, 2),
          updateDate: null,
          deleteFlag: false,
          artists: [],
        ),
        createDate: DateTime(2025, 6, 12),
        updateDate: null,
      ),
      EventLiveModel(
        liveCode: 'stream-003',
        name: 'BIG 콘서트',
        content: '최종 피날레 생중계!',
        profileImageUrl: 'assets/images/live.png',
        videoUrl: 'https://example.com/video3.mp4',
        taskDate: DateTime(2025, 6, 13, 18, 0),
        taskEndDate: DateTime(2025, 6, 13, 20, 30),
        eventYear: 2025,
        event: EventModel(
          eventCode: 'E003',
          name: 'BIG 콘서트',
          content: 'BIG 콘서트 피날레 스트리밍',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/banner_mokpo.png',
          profileUrl: 'assets/images/event_description_bof.png',
          preOpenDateTime: DateTime(2025, 6, 3),
          openDateTime: DateTime(2025, 6, 12),
          endDateTime: DateTime(2025, 6, 17),
          performanceStartTime: DateTime(2025, 6, 13, 18, 0),
          performanceEndTime: DateTime(2025, 6, 13, 20, 30),
          activeFlag: true,
          createDate: DateTime(2025, 5, 3),
          updateDate: null,
          deleteFlag: false,
          artists: [],
        ),
        createDate: DateTime(2025, 6, 13),
        updateDate: null,
      ),
    ];

    notifyListeners();
  }

  void clear() {
    _streamings = [];
    notifyListeners();
  }
}
