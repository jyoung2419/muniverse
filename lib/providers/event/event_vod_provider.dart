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
          shortName: '목포뮤플',
          performanceStartTime: DateTime(2025, 7, 15, 18, 0),
          performanceEndTime: DateTime(2025, 7, 18, 22, 0),
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
