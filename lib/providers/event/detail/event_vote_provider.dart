import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/detail/event_vote_model.dart';
import '../../../services/event/event_title_service.dart';
import '../../language_provider.dart';

class EventVoteProvider with ChangeNotifier {
  final List<EventVoteModel> _votes = [];
  List<EventVoteModel> get votes => _votes;

  final EventTitleService _service;
  final LanguageProvider _languageProvider;

  String? _eventCode;
  String? _status;

  EventVoteProvider(Dio dio, this._languageProvider)
      : _service = EventTitleService(dio) {
    _languageProvider.addListener(() {
      if (_eventCode != null && _status != null) {
        fetchVotes(_eventCode!, _status!);
      }
    });
  }

  Future<void> fetchVotes(String eventCode, String status) async {
    _eventCode = eventCode;
    _status = status;
    try {
      _votes.clear();
      final List<Map<String, dynamic>> data = await _service.fetchEventVoteList(eventCode, status);
      _votes.addAll(data.map((e) => EventVoteModel.fromJson(e)));
      notifyListeners();
    } catch (e) {
      print('❌ Vote 데이터 가져오기 실패: $e');
    }
  }

  void clear() {
    _votes.clear();
    _eventCode = null;
    _status = null;
    notifyListeners();
  }
}
