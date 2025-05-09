//수정 예정
import 'package:flutter/material.dart';
import '../../models/ticket/user_pass_model.dart';

class UserPassProvider with ChangeNotifier {
  final List<UserPass> _passes = [];

  List<UserPass> get passes => _passes;

  UserPassProvider() {
    fetchDummyUserPasses();
  }

  void fetchDummyUserPasses() {
    _passes.clear();

    _passes.add(
      UserPass(
        pinNumber: 'pass-001',
        userId: 'user001',
        passName: 'ALL PASS',
        createdAt: DateTime(2025, 4, 1),
        useFlag: true,
        events: [
          EventUseInfo(
            code: 'L001',
            type: UserPassType.STREAMING,
            pinNumber: 'pin-001',
            used: false,
            usedAt: null,
          ),
          EventUseInfo(
            code: 'L002',
            type: UserPassType.STREAMING,
            pinNumber: 'pin-002',
            used: false,
            usedAt: null,
          ),
          EventUseInfo(
            code: 'vod-001',
            type: UserPassType.VOD,
            pinNumber: 'vod-001',
            used: false,
            usedAt: null,
          ),
        ],
      ),
    );

    _passes.add(
        UserPass(
          pinNumber: 'pass-002',
          userId: 'user001',
          passName: '뮤니버스 올패스',
          createdAt: DateTime(2025, 4, 1),
          useFlag: true,
          events: [
            EventUseInfo(
              code: 'L001',
              type: UserPassType.STREAMING,
              pinNumber: 'pin-001',
              used: false,
              usedAt: null,
            ),
            EventUseInfo(
              code: 'vod-001',
              type: UserPassType.VOD,
              pinNumber: 'vod-001',
              used: false,
              usedAt: null,
            ),
          ],
        ),
    );

    notifyListeners();
  }

  void clear() {
    _passes.clear();
    notifyListeners();
  }
}
