import 'package:flutter/material.dart';
import '../models/artist_model.dart';

class ArtistProvider with ChangeNotifier {
  List<ArtistModel> _artists = [];

  List<ArtistModel> get artists => _artists;

  void fetchArtists() {
    _artists = [
      ArtistModel(
        artistCode: 'A001',
        name: '르세라핌',
        content: '글로벌 K-POP 아티스트',
        profileUrl: 'assets/images/lesserafim.png',
        artistType: 'GIRL',
        createDate: DateTime(2024, 1, 1),
        deleteFlag: false,
      ),
      // 추가 ArtistModel 더미 데이터 추가 가능
    ];

    notifyListeners();
  }

  ArtistModel? getArtistByCode(String code) {
    return _artists.firstWhere((a) => a.artistCode == code, orElse: () => null as ArtistModel);
  }
}
