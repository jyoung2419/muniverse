import 'package:flutter/material.dart';
import '../../models/ticket/live_ticket_model.dart';
import '../../models/user/user_model.dart';
import '../../models/event/event_live_model.dart';
import '../../models/event/event_model.dart';

class LiveTicketProvider with ChangeNotifier {
  List<LiveTicketModel> _tickets = [];

  List<LiveTicketModel> get tickets => _tickets;

  LiveTicketProvider() {
    fetchDummyTickets();
  }

  void fetchDummyTickets() {
    final dummyUser = UserModel(
      seq: 1,
      id: 'user001',
      password: 'password123',
      nickName: '홍길동',
      email: 'user@example.com',
      name: '홍길동',
      phoneNumber: '01012345678',
      profileUrl: 'assets/images/profile1.png',
      socialType: SocialType.NONE,
      regisStatus: true,
      createDate: DateTime(2025, 4, 1),
      updateDate: null,
      deleteFlag: false,
    );

    final dummyEvent = EventModel(
      eventCode: 'E001',
      name: 'BIG 콘서트',
      content: 'BIG 콘서트 현장 스트리밍',
      status: 'ACTIVE',
      bannerUrl: 'assets/images/mokpo_banner.png',
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
    );

    final dummyLive = EventLiveModel(
      liveCode: 'L001',
      name: 'BIG 콘서트',
      content: '생생한 무대 실황',
      profileImageUrl: 'assets/images/live.png',
      videoUrl: 'https://example.com/live.mp4',
      taskDate: DateTime(2025, 6, 11, 18),
      taskEndDate: DateTime(2025, 6, 11, 20),
      eventYear: 2025,
      event: dummyEvent,
      createDate: DateTime(2025, 5, 15),
      updateDate: null,
    );

    _tickets = [
      LiveTicketModel(
        livePinNumber: 'pin-001',
        useFlag: false,
        user: dummyUser,
        eventLive: dummyLive,
        createDate: DateTime(2025, 5, 20),
        useDate: null,
      ),
    ];

    notifyListeners();
  }
}
