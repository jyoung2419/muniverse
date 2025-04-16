import 'package:flutter/material.dart';
import '../models/vote_model.dart';

class VoteProvider with ChangeNotifier {
  List<VoteModel> _votes = [];

  List<VoteModel> get votes => _votes;

  void fetchVotes() {
    // 🔽 여기 실제 API 연결하거나 더미 데이터 넣기
    _votes = [
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'LESSERAFIM',
        artistNameKr: '르세라핌',
        imageUrl: 'assets/images/lesserafim.png',
        voteRate: 56.0,
        totalVotes: 40442,
        round: '1일차',
        status: '진행중',
        dateRange: '2025.03.31 ~ 2025.04.06',
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
        round: '2일차',
        status: '진행중',
        dateRange: '2025.04.14 ~ 2025.04.30',
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'KATSEYE',
        artistNameKr: '캣츠아이',
        imageUrl: 'assets/images/katseye.png',
        voteRate: 56.0,
        totalVotes: 40442,
        round: '3일차',
        status: '진행중',
        dateRange: '2025.04.01 ~ 2025.04.07',
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
        round: '1일차',
        status: '종료',
        dateRange: '2025.03.31 ~ 2025.04.06',
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'BABYMONSTER',
        artistNameKr: '베이비몬스터',
        imageUrl: 'assets/images/babymonster.png',
        voteRate: 56.0,
        totalVotes: 40442,
        round: '2일차',
        status: '진행중',
        dateRange: '2025.04.10 ~ 2025.04.15',
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'QWER',
        artistNameKr: '큐더블유이알',
        imageUrl: 'assets/images/qwer.png',
        voteRate: 56.0,
        totalVotes: 40442,
        round: '3일차',
        status: '진행중',
        dateRange: '2025.04.20 ~ 2025.04.25',
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
        round: '1일차',
        status: '진행중',
        dateRange: '2025.03.31 ~ 2025.04.06',
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
        round: '2일차',
        status: '진행중',
        dateRange: '2025.04.10 ~ 2025.04.15',
      ),
      VoteModel(
        topic: 'weekly',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/vote.png',
        voteRate: 33.0,
        totalVotes: 40442,
        round: '2일차',
        status: '진행중',
        dateRange: '2025.04.10 ~ 2025.04.15',
      ),
    ];

    notifyListeners();
  }
}
