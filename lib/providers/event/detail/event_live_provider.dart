import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/detail/event_live_model.dart';
import '../../../services/event/event_title_service.dart';

class EventLiveProvider with ChangeNotifier {
  final EventTitleService _eventTitleService;
  EventLiveProvider(Dio dio) : _eventTitleService = EventTitleService(dio);

  List<EventLiveModel> _lives = [];
  List<EventLiveModel> get lives => _lives;

  Future<void> fetchLives(String eventCode, int? eventYear) async {
    try {
      List<EventLiveModel> allLives = [];

      if (eventYear == null) {
        final years = [2025, 2024, 2023];

        for (final y in years) {
          final res = await _eventTitleService.fetchEventLiveList(eventCode, y);
          allLives.addAll(res.map((json) => EventLiveModel.fromJson(json)));
        }
      } else {
        final res = await _eventTitleService.fetchEventLiveList(eventCode, eventYear);
        allLives = res.map((json) => EventLiveModel.fromJson(json)).toList();
      }
      _lives = allLives;
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