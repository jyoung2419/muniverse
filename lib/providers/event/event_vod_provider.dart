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
        profileImageUrl: 'assets/images/vod.png', // ✅ 예시 이미지
        videoUrl: 'https://example.com/vod/video1.mp4', // ✅ 추후 실주소로 교체
        event: EventModel(
          eventCode: 'E001',
          name: '2025 MOKPO MUSICPLAY',
          content: '목포 뮤직플레이',
          status: 'ACTIVE',
          bannerUrl: 'assets/images/mokpo_banner.png',
          profileUrl: 'assets/images/event_description_bof.png',
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
        eventYear: 2025,
        openDate: DateTime(2025, 7, 15),
        createDate: DateTime.now(),
        updateDate: null,
      ),
    ];

    notifyListeners();
  }

  void clear() {
    _vods = [];
    notifyListeners();
  }
}
