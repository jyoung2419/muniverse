import 'package:flutter/material.dart';
import '../../models/artist/artist_model.dart';
import '../../models/artist/artist_group_model.dart';
import 'artist_provider.dart';

class ArtistGroupProvider with ChangeNotifier {
  final List<ArtistGroupModel> _groups = [];

  List<ArtistGroupModel> get groups => _groups;

  ArtistGroupProvider(ArtistProvider artistProvider) {
    _initDummyData(artistProvider);
  }

  void _initDummyData(ArtistProvider artistProvider) {
    final artists = artistProvider.artists;

    _groups.addAll([
      ArtistGroupModel(
        seq: 1,
        group: artists.firstWhere((a) => a.artistCode == 'A001'), // 르세라핌
        member: ArtistModel(
          artistCode: 'A101',
          name: '김채원',
          content: '르세라핌 리더',
          profileUrl: 'assets/images/member_kim.png',
          artistType: 'MEMBER',
          createDate: DateTime(2024, 1, 1),
          deleteFlag: false,
        ),
        createDate: DateTime(2024, 1, 10),
      ),
      ArtistGroupModel(
        seq: 2,
        group: artists.firstWhere((a) => a.artistCode == 'A004'), // 베이비몬스터
        member: ArtistModel(
          artistCode: 'A102',
          name: '아사',
          content: '베이비몬스터 멤버',
          profileUrl: 'assets/images/member_asa.png',
          artistType: 'MEMBER',
          createDate: DateTime(2024, 1, 2),
          deleteFlag: false,
        ),
        createDate: DateTime(2024, 1, 11),
      ),
    ]);
  }
}
