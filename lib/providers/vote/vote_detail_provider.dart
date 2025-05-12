import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/vote/vote_detail_model.dart';
import '../../services/vote/vote_service.dart';
import '../language_provider.dart';

class VoteDetailProvider with ChangeNotifier {
  VoteDetailModel? _voteDetail;
  VoteDetailModel? get voteDetail => _voteDetail;

  final VoteService _voteService;
  final LanguageProvider _languageProvider;

  String? _voteCode;

  VoteDetailProvider(Dio dio, this._languageProvider)
      : _voteService = VoteService(dio) {
    _languageProvider.addListener(() {
      if (_voteCode != null) {
        fetchVoteDetail(_voteCode!);
      }
    });
  }

  Future<void> fetchVoteDetail(String voteCode) async {
    _voteCode = voteCode;
    final response = await _voteService.getVoteDetail(voteCode);
    _voteDetail = VoteDetailModel.fromJson(response);
    notifyListeners();
  }

  void clear() {
    _voteDetail = null;
    _voteCode = null;
    notifyListeners();
  }
}
