import 'dart:math';
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
    _voteArtists.clear();

    final voteMap = {
      'V001': ['A001', 'A002', 'A003', 'A004', 'A005', 'A006', 'A007', 'A008', 'A009', 'A010'],
      'V002': ['A002', 'A003', 'A004', 'A006', 'A007', 'A008',],
      'V003': ['A003', 'A005', 'A009', 'A010'],
      'V004': ['A001', 'A002', 'A003', 'A004', 'A005', 'A006', 'A007', 'A008',],
      'V005': ['A001', 'A002', 'A003', 'A004', 'A005', 'A009', 'A010'],
    };

    final random = Random();
    int seq = 1;
    for (final entry in voteMap.entries) {
      final vote = votes.firstWhere((v) => v.voteCode == entry.key);
      for (final artistCode in entry.value) {
        final artist = artists.firstWhere((a) => a.artistCode == artistCode);
        _voteArtists.add(VoteArtistModel(
          seq: seq++,
          voteCount: 500 + random.nextInt(5000), // 500~5499 랜덤
          artist: artist,
          vote: vote,
          createDate: DateTime.now(),
        ));
      }
    }

    notifyListeners();
  }

  List<VoteArtistModel> getVoteArtistsByVoteCode(String voteCode) {
    return _voteArtists.where((v) => v.vote.voteCode == voteCode).toList();
  }
}
