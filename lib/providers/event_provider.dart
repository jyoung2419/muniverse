import '../models/event_model.dart';

final List<EventModel> eventList = [
  EventModel(
    id: 1,
    title: '2025 MOKPO MUSICPLAY',
    description: '목포 뮤직플레이',
    bannerImg: 'assets/images/banner_mokpo.png',
    startDate: DateTime(2025, 7, 15),
    endDate: DateTime(2025, 7, 18),
  ),
  EventModel(
    id: 2,
    title: 'BUSAN ONE ASIA FESTIVAL',
    description: '부산 원아시아 페스티벌',
    bannerImg: 'assets/images/banner_bof.png',
    startDate: DateTime(2025, 9, 10),
    endDate: DateTime(2025, 9, 13),
  ),
];
