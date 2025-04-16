import 'package:flutter/material.dart';
import '../../models/event/event_streaming_model.dart';
import '../../models/event/event_model.dart';

class EventStreamingProvider with ChangeNotifier {
  List<EventStreamingModel> _streamings = [];

  List<EventStreamingModel> get streamings => _streamings;

  EventStreamingProvider() {
    fetchDummyStreamings();
  }

  void fetchDummyStreamings() {
    _streamings = [
      EventStreamingModel(
        streamingCode: 'stream-001',
        name: 'BIG 콘서트',
        content: '생생한 무대 실황',
        event: EventModel(
          eventCode: 'EVT001',
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
        imagePath: 'assets/images/live.png',
      ),
      EventStreamingModel(
        streamingCode: 'stream-002',
        name: 'K-POP 밴드 콘서트',
        content: '밴드의 열정 가득한 무대',
        event: EventModel(
          eventCode: 'EVT002',
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
        imagePath: 'assets/images/live.png',
      ),
      EventStreamingModel(
        streamingCode: 'stream-003',
        name: 'BIG 콘서트',
        content: '최종 피날레 생중계!',
        event: EventModel(
          eventCode: 'EVT003',
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
        imagePath: 'assets/images/live.png',
      ),
    ];

    notifyListeners();
  }

  void clear() {
    _streamings = [];
    notifyListeners();
  }
}
