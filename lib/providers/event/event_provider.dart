import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';

class EventProvider with ChangeNotifier {
  final List<EventModel> _events = [
    EventModel(
      eventCode: 'code',
      name: '상시 이벤트',
      content: '항상 존재하는 고정 이벤트입니다.',
      status: 'OPEN',
      bannerUrl: '',
      profileUrl: '',
      cardUrl: '',
      introContent: '',
      manager: '',
      shortName: '',
      preOpenDateTime: DateTime(2025, 4, 23, 15, 36, 46),
      openDateTime: DateTime(2025, 4, 23, 15, 36, 46),
      endDateTime: DateTime(2999, 12, 31, 23, 59),
      performanceStartTime: DateTime(2025, 4, 23, 15, 36, 46),
      performanceEndTime: DateTime(2999, 12, 31, 23, 59),
      activeFlag: true,
      createDate: DateTime(2025, 4, 23, 15, 36, 46),
      updateDate: null,
      deleteFlag: false,
      artists: null,
    ),
    EventModel(
      eventCode: 'E001',
      name: '2025 MOKPO MUSICPLAY',
      content: '목포 뮤직플레이',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/mokpo_banner.png',
      profileUrl: 'assets/images/mokpo_profile.png',
      cardUrl: 'assets/images/mokpo_card.png',
      introContent: '국내외 아티스트와 함께하는 목포 최대 뮤직 축제!',
      manager: 'admin01',
      shortName: '목포뮤플',
      preOpenDateTime: DateTime(2025, 4, 1),
      openDateTime: DateTime(2025, 4, 15),
      endDateTime: DateTime(2025, 5, 18),
      performanceStartTime: DateTime(2025, 5, 15, 18, 0),
      performanceEndTime: DateTime(2025, 5, 18, 22, 0),
      activeFlag: true,
      createDate: DateTime(2025, 4, 1),
      updateDate: null,
      deleteFlag: false,
      artists: null,
    ),
    EventModel(
      eventCode: 'E002',
      name: 'BUSAN ONE ASIA FESTIVAL',
      content: '부산 원아시아 페스티벌',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/bof_banner.png',
      profileUrl: 'assets/images/bof_profile.png',
      cardUrl: 'assets/images/bof_card.png',
      introContent: '부산의 대표 음악 축제!',
      manager: 'admin02',
      shortName: 'BOF',
      preOpenDateTime: DateTime(2025, 6, 5),
      openDateTime: DateTime(2025, 6, 10),
      endDateTime: DateTime(2025, 6, 13),
      performanceStartTime: DateTime(2025, 6, 10, 17, 0),
      performanceEndTime: DateTime(2025, 6, 13, 21, 0),
      activeFlag: true,
      createDate: DateTime(2025, 4, 15),
      updateDate: null,
      deleteFlag: false,
      artists: null,
    ),
    EventModel(
      eventCode: 'E004',
      name: 'BUSAN ONE ASIA FESTIVAL',
      content: '부산 원아시아 페스티벌',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/bof_banner.png',
      profileUrl: 'assets/images/bof_profile.png',
      cardUrl: 'assets/images/bof_card.png',
      introContent: 'K-POP과 함께하는 글로벌 음악 축제!',
      manager: 'admin02',
      shortName: 'BOF',
      preOpenDateTime: DateTime(2025, 6, 5),
      openDateTime: DateTime(2025, 6, 10),
      endDateTime: DateTime(2025, 6, 13),
      performanceStartTime: DateTime(2025, 6, 10, 17, 0),
      performanceEndTime: DateTime(2025, 6, 13, 21, 0),
      activeFlag: true,
      createDate: DateTime(2025, 4, 15),
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
