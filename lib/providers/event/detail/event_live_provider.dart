import 'package:flutter/material.dart';
import '../../../models/event/detail/event_live_model.dart';
import '../../../services/event/event_title_service.dart';

class EventLiveProvider with ChangeNotifier {
  final EventTitleService _eventTitleService = EventTitleService();

  List<EventLiveModel> _lives = [];
  List<EventLiveModel> get lives => _lives;

  Future<void> fetchLives(String eventCode, int eventYear) async {
    try {
      final List<Map<String, dynamic>> responseList =
      await _eventTitleService.fetchEventLiveList(eventCode, eventYear);
      _lives = responseList.map((json) => EventLiveModel.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('❌ Live 불러오기 실패: \$e');
      rethrow;
    }
  }

  void clear() {
    _lives = [];
    notifyListeners();
  }
}