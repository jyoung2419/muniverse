import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/detail/event_model.dart';
import '../../../services/event/event_title_service.dart';

class EventProvider with ChangeNotifier {
  final List<EventModel> _events = [];
  final EventTitleService _eventTitleService;
  EventProvider(Dio dio) : _eventTitleService = EventTitleService(dio);

  List<EventModel> get events => _events;

  Future<void> fetchAndAddEvent(String eventCode) async {
    try {
      final json = await _eventTitleService.fetchEventTitle(eventCode);

      final newEvent = EventModel.fromJson(json, eventCode);

      final index = _events.indexWhere((e) => e.eventCode == eventCode);
      if (index >= 0) {
        _events[index] = newEvent;
      } else {
        _events.add(newEvent);
      }
      notifyListeners();
    } catch (e) {
      print('❌ 이벤트 로딩 실패: $e');
    }
  }

  EventModel? getEventByCode(String code) {
    try {
      return _events.firstWhere((e) => e.eventCode == code);
    } catch (_) {
      return null;
    }
  }
}
