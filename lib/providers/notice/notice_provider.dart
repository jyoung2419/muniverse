import 'package:flutter/material.dart';
import '../../models/notice/notice_model.dart';

class NoticeProvider with ChangeNotifier {
  final List<NoticeModel> _notices = [];

  List<NoticeModel> get notices => _notices;

  NoticeProvider() {
    _loadDummyNotices();
  }

  void _loadDummyNotices() {
    _notices.clear();
    _notices.addAll([
      NoticeModel(
        seq: 1,
        title: '[안내] 2025 MUNIVERSE 서비스 정기점검 안내',
        content: '''
안녕하세요, 뮤니버스입니다.
뮤니버스를 이용하시는 고객님께 감사드립니다.

뮤니버스 시스템 점검 안내입니다.

1. 점검 일시 : 2025.04.09 (수) 04:00 ~ 04:25

시스템 점검으로 안내된 시간 동안은 구매/취소가 불가합니다.

* 서비스 일시 중단 시간은 작업 진행에 따라 다소 변경될 수 있습니다.

이용에 불편 드려 죄송합니다.
감사합니다.
''',
        active: true,
        displayOrder: 1,
        createDate: DateTime.parse('2025-04-09'),
        updateDate: null,
      ),
      NoticeModel(
        seq: 2,
        title: '[이벤트] 2025 MOKPO MUSICPLAY 투표 이벤트 오픈!',
        content: '이벤트에 참여하고 선물을 받아보세요! 투표는 4/15까지 가능합니다.',
        active: true,
        displayOrder: 2,
        createDate: DateTime.parse('2025-04-08'),
        updateDate: null,
      ),
      NoticeModel(
        seq: 3,
        title: '[업데이트] 아티스트 상세 페이지 리뉴얼 안내',
        content: '아티스트 상세 페이지가 더욱 보기 좋게 리뉴얼 되었습니다.',
        active: true,
        displayOrder: 3,
        createDate: DateTime.parse('2025-04-08'),
        updateDate: null,
      ),
      NoticeModel(
        seq: 4,
        title: '[공지] 회원가입 시 이메일 인증 방식 변경 안내',
        content: '보안을 위해 이메일 인증 방식이 개선되었습니다.',
        active: true,
        displayOrder: 4,
        createDate: DateTime.parse('2025-04-08'),
        updateDate: null,
      ),
      NoticeModel(
        seq: 5,
        title: '[공지] 개인정보처리방침 변경 안내 (5월 1일부터)',
        content: '2025년 5월 1일부터 새로운 개인정보처리방침이 적용됩니다.',
        active: true,
        displayOrder: 5,
        createDate: DateTime.parse('2025-04-08'),
        updateDate: null,
      ),
    ]);
    notifyListeners();
  }

  void clear() {
    _notices.clear();
    notifyListeners();
  }
}
