//수정 예정
import 'package:flutter/material.dart';
import '../../models/ticket/vote_ticket_model.dart';
import '../../models/user/user_model.dart';

class VoteTicketProvider with ChangeNotifier {
  final List<VoteTicketModel> _tickets = [];

  List<VoteTicketModel> get tickets => _tickets;

  VoteTicketProvider() {
    _loadDummyTickets();
  }

  void _loadDummyTickets() {
    final user1 = UserModel(
      seq: 1,
      id: 'user001',
      password: 'password123',
      nickName: '뮤니',
      email: 'muniverse01@email.com',
      name: '김뮤니',
      phoneNumber: '01012345678',
      profileUrl: 'assets/images/profile1.png',
      socialType: SocialType.GOOGLE,
      regisStatus: true,
      createDate: DateTime(2025, 4, 1),
      updateDate: null,
      deleteFlag: false,
    );

    final user2 = UserModel(
      seq: 2,
      id: 'user002',
      password: 'securepwd456',
      nickName: '우주',
      email: 'woojoo@email.com',
      name: '이우주',
      phoneNumber: '01087654321',
      profileUrl: 'assets/images/profile2.png',
      socialType: SocialType.X,
      regisStatus: true,
      createDate: DateTime(2025, 4, 3),
      updateDate: DateTime(2025, 4, 10),
      deleteFlag: false,
    );

    _tickets.addAll([
      VoteTicketModel(
        votePinNumber: 'VT001-AAAA',
        useFlag: false,
        user: user1,
        createDate: DateTime(2025, 4, 15, 10, 0),
        useDate: null,
      ),
      VoteTicketModel(
        votePinNumber: 'VT002-BBBB',
        useFlag: true,
        user: user2,
        createDate: DateTime(2025, 4, 12, 9, 0),
        useDate: DateTime(2025, 4, 14, 18, 0),
      ),
    ]);

    notifyListeners();
  }

  List<VoteTicketModel> getTicketsByUserId(String userId) {
    return _tickets.where((t) => t.user.id == userId).toList();
  }

  VoteTicketModel? getTicketByPin(String pin) {
    try {
      return _tickets.firstWhere((t) => t.votePinNumber == pin);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _tickets.clear();
    notifyListeners();
  }
}
