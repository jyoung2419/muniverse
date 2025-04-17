import 'package:flutter/material.dart';
import '../../models/vote/vote_model.dart';

class VoteProvider with ChangeNotifier {
  final List<VoteModel> _votes = [
    VoteModel(
      voteCode: 'V001',
      voteName: '최고 인기 여자 아이돌',
      content: '전 세계에서 가장 인기 있는 여자 아이돌은 누구인가요?',
      voteImageUrl: 'assets/images/vote2.png',
      freeCountLimit: 3,
      eventCode: 'E001',
      rewardContent: '아티스트에게 특별 굿즈 증정',
      startTime: DateTime(2025, 5, 1, 0, 0),
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
      voteImageUrl: 'assets/images/vote3.png',
      freeCountLimit: 2,
      eventCode: 'E001',
      rewardContent: '상위 3팀 팬미팅 기회 제공',
      startTime: DateTime(2025, 4, 20, 0, 0),
      endTime: DateTime(2025, 4, 25, 23, 59),
      resultOpenTime: DateTime(2025, 4, 26, 12, 0),
      createDate: DateTime(2025, 4, 3, 9, 0),
      updateDate: null,
      deleteFlag: false,
    ),
    VoteModel(
      voteCode: 'V003',
      voteName: '차세대 기대주',
      content: '다음 세대의 K-POP을 이끌 신인 그룹은?',
      voteImageUrl: 'assets/images/vote1.png',
      freeCountLimit: 1,
      eventCode: 'E001',
      rewardContent: '아티스트 뮤직비디오 제작 지원',
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
      voteImageUrl: 'assets/images/vote1.png',
      freeCountLimit: 5,
      eventCode: 'E002',
      rewardContent: '팬 감사 라이브 방송 진행',
      startTime: DateTime(2025, 4, 1, 0, 0),
      endTime: DateTime(2025, 4, 30, 23, 59),
      resultOpenTime: DateTime(2025, 5, 1, 12, 0),
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
}
