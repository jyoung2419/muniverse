import 'package:flutter/material.dart';
import '../../models/ticket/base_ticket.dart';
import '../../models/ticket/streaming_ticket_model.dart';
import '../../models/ticket/vod_ticket_model.dart';
import '../../models/user/user_model.dart';
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
        startTime: DateTime(2025, 7, 15, 20, 0),
        endTime: DateTime(2025, 7, 15, 22, 0),
        expiredDate: 7,
        useFlag: false,
        user: UserModel(
          seq: 1,
          id: 'user001',
          password: 'password123',
          nickName: '뮤니',
          email: 'muniverse01@email.com',
          name: '김뮤니',
          phoneNumber: '01012345678',
          profileUrl: 'assets/images/profile1.png',
          socialType: 'GOOGLE',
          regisStatus: true,
          createDate: DateTime(2025, 4, 1),
          updateDate: null,
          deleteFlag: false,
        ),
        event: EventModel(
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
