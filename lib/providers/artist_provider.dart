import 'package:flutter/material.dart';
import '../models/artist_model.dart';

class ArtistProvider with ChangeNotifier {
  final List<ArtistModel> _artists = [
    ArtistModel(
      artistCode: 'A001',
      name: '르세라핌',
      content: '차세대 글로벌 K-POP 걸그룹',
      profileUrl: 'assets/images/lesserafim.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 1),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A002',
      name: '더킹덤',
      content: '강렬한 퍼포먼스의 보이 그룹',
      profileUrl: 'assets/images/thekingdom.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 2),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A003',
      name: '캣츠아이',
      content: '글로벌 프로젝트 걸그룹',
      profileUrl: 'assets/images/katseye.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 3),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A004',
      name: '베이비몬스터',
      content: 'Y** 신예 걸그룹',
      profileUrl: 'assets/images/babymonster.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 4),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A005',
      name: '큐더블유이알',
      content: '밴드 기반 신인 걸그룹',
      profileUrl: 'assets/images/qwer.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 5),
      deleteFlag: false,
    ),
  ];

  List<ArtistModel> get artists => _artists;

  ArtistModel? getArtistByCode(String code) {
    try {
      return _artists.firstWhere((a) => a.artistCode == code);
    } catch (_) {
      return null;
    }
  }
}
