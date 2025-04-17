import 'package:flutter/material.dart';
import '../../models/vote/vote_artist_model.dart';
import '../../models/vote/vote_model.dart';
import '../../models/artist/artist_model.dart';

class VoteArtistProvider with ChangeNotifier {
  final List<VoteArtistModel> _voteArtists = [];

  List<VoteArtistModel> get voteArtists => _voteArtists;

  void fetchVoteArtists({
    required List<VoteModel> votes,
    required List<ArtistModel> artists,
  }) {
    _voteArtists.clear(); // 기존 데이터 초기화

    _voteArtists.addAll([
      VoteArtistModel(
        seq: 1,
        voteCount: 12345,
        artist: artists.firstWhere((a) => a.artistCode == 'A001'),
        vote: votes.firstWhere((v) => v.voteCode == 'V001'),
        createDate: DateTime(2025, 4, 10),
      ),
      VoteArtistModel(
        seq: 2,
        voteCount: 9876,
        artist: artists.firstWhere((a) => a.artistCode == 'A002'),
        vote: votes.firstWhere((v) => v.voteCode == 'V002'),
        createDate: DateTime(2025, 4, 20),
      ),
    ]);

    notifyListeners();
  }

  List<VoteArtistModel> getVoteArtistsByVoteCode(String voteCode) {
    return _voteArtists.where((v) => v.vote.voteCode == voteCode).toList();
  }
}
