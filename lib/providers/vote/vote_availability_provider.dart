import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/vote/vote_availability_model.dart';
import '../../services/vote/vote_service.dart';

class VoteAvailabilityProvider with ChangeNotifier {
  final VoteService _voteService;
  VoteAvailabilityProvider(Dio dio) : _voteService = VoteService(dio);

  VoteAvailabilityModel? _availability;
  VoteAvailabilityModel? get availability => _availability;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchVoteAvailability(String voteCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _voteService.getVoteAvailability(voteCode);
      _availability = VoteAvailabilityModel.fromJson(response);
    } catch (e) {
      _error = '무료 투표권 정보를 불러오는 데 실패했습니다.';
      print('❌ fetchVoteAvailability 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _availability = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
