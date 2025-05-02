// 필요 x 수정 예정
import 'package:flutter/material.dart';
import '../../models/vote/vote_model.dart';

class VoteProvider with ChangeNotifier {
  final List<VoteModel> _votes = [
    VoteModel(
      voteCode: 'V001',
      voteName: '최고 인기 여자 아이돌',
      content: '전 세계에서 가장 인기 있는 여자 아이돌은 누구인가요?',
      voteImageUrl: 'assets/images/vote/vote2.png',
      freeCountLimit: 3,
      eventCode: 'E001',
      startTime: DateTime(2025, 4, 14, 0, 0),
      endTime: DateTime(2025, 5, 5, 23, 59),
      resultOpenTime: DateTime(2025, 5, 6, 12, 0),
      createDate: DateTime(2025, 4, 15, 8, 0),
      updateDate: null,
      deleteFlag: false,
    ),
    VoteModel(
      voteCode: 'V002',
      voteName: '최고 인기 남자 아이돌',
      content: '2025년 상반기 최고의 남자 아이돌을 뽑아주세요!',
      voteImageUrl: 'assets/images/vote/vote3.png',
      freeCountLimit: 2,
      eventCode: 'E001',
      startTime: DateTime(2025, 4, 20, 0, 0),
      endTime: DateTime(2025, 4, 23, 23, 59),
      resultOpenTime: DateTime(2025, 4, 26, 12, 0),
      createDate: DateTime(2025, 4, 3, 9, 0),
      updateDate: null,
      deleteFlag: false,
    ),
    VoteModel(
      voteCode: 'V003',
      voteName: '차세대 기대주',
      content: '다음 세대의 K-POP을 이끌 신인 그룹은?',
      voteImageUrl: 'assets/images/vote/vote1.png',
      freeCountLimit: 1,
      eventCode: 'E001',
      startTime: DateTime(2025, 4, 10, 0, 0),
      endTime: DateTime(2025, 4, 15, 23, 59),
      resultOpenTime: DateTime(2025, 4, 16, 12, 0),
      createDate: DateTime(2025, 4, 1, 10, 0),
      updateDate: DateTime(2025, 4, 5, 15, 0),
      deleteFlag: false,
    ),
    VoteModel(
      voteCode: 'V004',
      voteName: '월간 팬 인기 투표',
      content: '기대되는 3월 컴백 아이돌은 누구인가요?',
      voteImageUrl: 'assets/images/vote/vote1.png',
      freeCountLimit: 5,
      eventCode: 'E001',
      startTime: DateTime(2025, 4, 22, 0, 0),
      endTime: DateTime(2025, 4, 30, 23, 59),
      resultOpenTime: DateTime(2025, 5, 1, 12, 0),
      createDate: DateTime(2025, 3, 28, 11, 0),
      updateDate: null,
      deleteFlag: false,
    ),
    VoteModel(
      voteCode: 'V005',
      voteName: '주간 인기 투표',
      content: '기대되는 3월 컴백 아이돌은 누구인가요?',
      voteImageUrl: 'assets/images/vote/vote1.png',
      freeCountLimit: 5,
      eventCode: 'code',
      startTime: DateTime(2025, 4, 11, 0, 0),
      endTime: DateTime(2025, 4, 16, 23, 59),
      resultOpenTime: DateTime(2025, 4, 19, 12, 0),
      createDate: DateTime(2025, 3, 28, 11, 0),
      updateDate: null,
      deleteFlag: false,
    ),
  ];

  List<VoteModel> get votes => _votes;

  VoteModel? getVoteByCode(String code) {
    try {
      return _votes.firstWhere((v) => v.voteCode == code);
    } catch (_) {
      return null;
    }
  }

  List<VoteModel> filterVotes(String status, String eventCode) {
    final now = DateTime.now();
    return _votes.where((vote) {
      if (vote.eventCode != eventCode) return false;
      switch (status) {
        case '전체':
          return true;
        case '진행중':
          return now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
        case '진행완료':
          return now.isAfter(vote.endTime) || now.isAtSameMomentAs(vote.endTime);
        case '진행예정':
          return now.isBefore(vote.startTime);
        default:
          return false;
      }
    }).toList();
  }
  List<VoteModel> filterAllVotes(String status) {
    final now = DateTime.now();
    return _votes.where((vote) {
      switch (status) {
        case '전체':
          return true;
        case '진행중':
          return now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
        case '진행완료':
          return now.isAfter(vote.endTime) || now.isAtSameMomentAs(vote.endTime);
        case '진행예정':
          return now.isBefore(vote.startTime);
        default:
          return false;
      }
    }).toList();
  }

}
