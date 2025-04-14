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
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'KATSEYE',
        artistNameKr: '캣츠아이',
        imageUrl: 'assets/images/katseye.png',
        voteRate: 56.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'LESSERAFIM',
        artistNameKr: '르세라핌',
        imageUrl: 'assets/images/lesserafim.png',
        voteRate: 56.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 여자 아이돌',
        artistName: 'LESSERAFIM',
        artistNameKr: '르세라핌',
        imageUrl: 'assets/images/lesserafim.png',
        voteRate: 56.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
      ),
      VoteModel(
        topic: '최고 인기 남자 아이돌',
        artistName: 'The KingDom',
        artistNameKr: '더킹덤',
        imageUrl: 'assets/images/thekingdom.png',
        voteRate: 33.0,
        totalVotes: 40442,
      ),
    ];

    notifyListeners();
  }
}
