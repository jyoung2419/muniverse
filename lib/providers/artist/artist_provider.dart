import 'package:flutter/material.dart';
import '../../models/artist/artist_model.dart';

class ArtistProvider with ChangeNotifier {
  final List<ArtistModel> _artists = [
    ArtistModel(
      artistCode: 'A001',
      name: '르세라핌',
      content: 'LESSRAFIM',
      profileUrl: 'assets/images/artist/lesserafim.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 1),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A002',
      name: '더킹덤',
      content: 'THE KINGDOM',
      profileUrl: 'assets/images/artist/thekingdom.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 2),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A003',
      name: '캣츠아이',
      content: 'KATSEYE',
      profileUrl: 'assets/images/artist/katseye.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 3),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A004',
      name: '베이비몬스터',
      content: 'BABYMONSTER',
      profileUrl: 'assets/images/artist/babymonster.png',
      artistType: 'GROUP',
      createDate: DateTime(2024, 1, 4),
      deleteFlag: false,
    ),
    ArtistModel(
      artistCode: 'A005',
      name: '큐더블유이알',
      content: 'QWER',
      profileUrl: 'assets/images/artist/qwer.png',
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
