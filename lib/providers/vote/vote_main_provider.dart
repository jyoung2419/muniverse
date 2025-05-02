import 'package:flutter/material.dart';
import '../../models/vote/vote_main_model.dart';
import '../../services/vote/vote_service.dart';

class VoteMainProvider with ChangeNotifier {
  final VoteService _voteService = VoteService();

  List<VoteMainModel> _votes = [];
  List<VoteMainModel> get votes => _votes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchVotesByStatus(String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rawData = await _voteService.getVotesByStatus(status);
      _votes = rawData.map((json) => VoteMainModel.fromJson(json)).toList();
    } catch (e) {
      _error = '투표 목록을 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
