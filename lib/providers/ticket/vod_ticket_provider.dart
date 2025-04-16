import 'package:flutter/material.dart';
import '../../models/ticket/vod_ticket_model.dart';
import '../../models/user_model.dart';
import '../../models/event/event_model.dart';

class VODTicketProvider with ChangeNotifier {
  List<VODTicket> _tickets = [];

  List<VODTicket> get tickets => _tickets;

  Future<void> fetchTickets(String userId) async {
    _tickets = [
      VODTicket(
        vodPinNumber: 'vod-001',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        expiredDate: 7,
        useFlag: false,
        user: User(id: userId, name: '홍길동'),
        event: EventModel(
          eventCode: 'EVT001',
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
          artists: [], // 비워두거나 ArtistModel 예시 넣을 수 있음
        ),
        vodExImg: 'assets/images/vod.png', // ✅ 예시 이미지 경로 추가

        createDate: DateTime.now(),
      ),
    ];

    notifyListeners();
  }


  void clear() {
    _tickets = [];
    notifyListeners();
  }
}
