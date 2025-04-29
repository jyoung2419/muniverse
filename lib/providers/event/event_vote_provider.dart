import 'package:flutter/material.dart';
import '../../models/event/event_vote_model.dart';
import '../../services/event/event_title_service.dart';

class EventVoteProvider with ChangeNotifier {
  final List<EventVoteModel> _votes = [];
  List<EventVoteModel> get votes => _votes;

  final EventTitleService _service = EventTitleService();

  Future<void> fetchVotes(String eventCode, String status) async {
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
    notifyListeners();
  }
}
