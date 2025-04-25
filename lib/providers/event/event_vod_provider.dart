import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';
import '../../models/event/event_vod_model.dart';

class EventVODProvider with ChangeNotifier {
  List<EventVODModel> _vods = [];

  List<EventVODModel> get vods => _vods;

  Future<void> fetchDummyVODs() async {
    _vods = [
      EventVODModel(
        vodCode: 'vod-001',
        name: '2025 MOKPO MUSICPLAY',
        content: '목포 뮤직플레이 다시보기',
        profileImageUrl: 'assets/images/vod.png',
        videoUrl: 'https://example.com/vod/video1.mp4',
        eventYear: 2025,
        round: 1,
        createDate: DateTime(2025, 6, 1),
        endDate: DateTime(2025, 7, 18),
        openDate: DateTime(2025, 7, 15),
        updateDate: null,
        eventCode: 'E001',
        event: EventModel(
          eventCode: 'E001',
          name: '2025 MOKPO MUSICPLAY',
          content: '목포 뮤직플레이',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/mokpo_banner.png',
          profileUrl: 'assets/images/event_description_bof.png',
          cardUrl: 'assets/images/mokpo_card.png',
          introContent: '국내외 아티스트와 함께하는 목포 최대 뮤직 축제!',
          manager: 'admin01',
          shortName: '목포뮤플',
          preOpenDateTime: DateTime(2025, 7, 1),
          openDateTime: DateTime(2025, 7, 15),
          endDateTime: DateTime(2025, 7, 18),
          performanceStartTime: DateTime(2025, 7, 15, 18, 0),
          performanceEndTime: DateTime(2025, 7, 18, 22, 0),
          activeFlag: true,
          createDate: DateTime(2025, 6, 1),
          updateDate: null,
          deleteFlag: false,
          artists: [],
        ),
      ),
    ];

    notifyListeners();
  }

  void clear() {
    _vods = [];
    notifyListeners();
  }
}
