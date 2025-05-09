import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/main/event_main_model.dart';
import '../../../services/event/event_main_service.dart';

class EventMainProvider with ChangeNotifier {
  final List<EventMainModel> _events = [];

  final EventMainService _eventService;
  EventMainProvider(Dio dio) : _eventService = EventMainService(dio);

  List<EventMainModel> get events => _events;

  Future<void> fetchMainEvents() async {
    try {
      final response = await _eventService.fetchMainEvents();
      print('✅ Event response length: ${response.length}');
      _events
        ..clear()
        ..addAll(response.map((e) => EventMainModel.fromJson(e)));
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error fetching main events: $e');
    }
  }


  EventMainModel? getEventByCode(String code) {
    try {
      return _events.firstWhere((e) => e.eventCode == code);
    } catch (_) {
      return null;
    }
  }
}