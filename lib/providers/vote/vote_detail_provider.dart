import 'package:flutter/material.dart';
import '../../models/vote/vote_detail_model.dart';
import '../../services/vote/vote_service.dart';

class VoteDetailProvider with ChangeNotifier {
  VoteDetailModel? _voteDetail;

  VoteDetailModel? get voteDetail => _voteDetail;

  final VoteService _voteService = VoteService();

  Future<void> fetchVoteDetail(String voteCode) async {
    final response = await _voteService.getVoteDetail(voteCode);
    _voteDetail = VoteDetailModel.fromJson(response);
    notifyListeners();
  }

  void clear() {
    _voteDetail = null;
    notifyListeners();
  }
}
