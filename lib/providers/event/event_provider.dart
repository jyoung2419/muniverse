import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';

class EventProvider with ChangeNotifier {
  final List<EventModel> _events = [
    EventModel(
      eventCode: 'E001',
      name: '2025 MOKPO MUSICPLAY',
      content: '목포 뮤직플레이',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/banner_mokpo.png',
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
      artists: null,
    ),
    EventModel(
      eventCode: 'E002',
      name: 'BUSAN ONE ASIA FESTIVAL',
      content: '부산 원아시아 페스티벌',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/banner_bof.png',
      profileUrl: 'assets/images/event_description_bof.png',
      preOpenDateTime: DateTime(2025, 8, 20),
      openDateTime: DateTime(2025, 9, 10),
      endDateTime: DateTime(2025, 9, 13),
      performanceStartTime: DateTime(2025, 9, 10, 17, 0),
      performanceEndTime: DateTime(2025, 9, 13, 21, 0),
      activeFlag: true,
      createDate: DateTime(2025, 6, 15),
      updateDate: null,
      deleteFlag: false,
      artists: null,
    ),
  ];

  List<EventModel> get events => _events;

  EventModel? getEventByCode(String code) {
    try {
      return _events.firstWhere((e) => e.eventCode == code);
    } catch (_) {
      return null;
    }
  }
}
