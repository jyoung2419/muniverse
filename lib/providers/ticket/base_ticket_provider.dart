import 'package:flutter/material.dart';
import '../../models/ticket/base_ticket.dart';
import '../../models/ticket/streaming_ticket_model.dart';
import '../../models/ticket/vod_ticket_model.dart';
import '../../models/user_model.dart';
import '../../models/event/event_model.dart';

class BaseTicketProvider with ChangeNotifier {
  final List<BaseTicket> _tickets = [];

  List<BaseTicket> get tickets => _tickets;

  BaseTicketProvider() {
    fetchDummyAllTickets();
  }

  void fetchDummyAllTickets() {
    _tickets.clear();

    // 🎟️ 더미 StreamingTicket
    _tickets.addAll([
      StreamingTicket(
        streamingPinNumber: 'pin-001',
        useFlag: false,
        eventTitle: 'BIG 콘서트',
        eventDate: DateTime(2025, 6, 11),
        imagePath: 'assets/images/ticket.png',
      ),
      StreamingTicket(
        streamingPinNumber: 'pin-002',
        useFlag: false,
        eventTitle: 'K-POP 밴드 콘서트',
        eventDate: DateTime(2025, 6, 12),
        imagePath: 'assets/images/ticket.png',
      ),
    ]);

    // 🎟️ 더미 VODTicket
    _tickets.add(
      VODTicket(
        vodPinNumber: 'vod-001',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        expiredDate: 7,
        useFlag: false,
        user: User(id: 'user001', name: '홍길동'),
        event: EventModel(
          eventCode: 'EVT001',
          name: '2025 MOKPO MUSICPLAY',
          content: '목포 뮤직플레이',
          status: 'ACTIVE',
          bannerUrl: '',
          profileUrl: '',
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
        vodExImg: 'assets/images/ticket.png',
        createDate: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void clear() {
    _tickets.clear();
    notifyListeners();
  }
}
