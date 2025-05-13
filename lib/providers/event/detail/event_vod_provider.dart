import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/detail/event_vod_model.dart';
import '../../../services/event/event_title_service.dart';

class EventVODProvider with ChangeNotifier {
  final EventTitleService _eventTitleService;
  EventVODProvider(Dio dio) : _eventTitleService = EventTitleService(dio);

  List<EventVODModel> _vods = [];

  List<EventVODModel> get vods => _vods;

  Future<void> fetchVODs(String eventCode, int? eventYear) async {
    try {
      List<EventVODModel> allVods = [];

      if (eventYear == null) {
        final years = [2025, 2024, 2023];
        for (final y in years) {
          final res = await _eventTitleService.fetchEventVODList(eventCode, y);
          allVods.addAll(res.map((json) => EventVODModel.fromJson(json)));
        }
      } else {
        final res = await _eventTitleService.fetchEventVODList(eventCode, eventYear);
        allVods = res.map((json) => EventVODModel.fromJson(json)).toList();
      }

      _vods = allVods;
      notifyListeners();
    } catch (e) {
      print('❌ VOD 불러오기 실패: $e');
      rethrow;
    }
  }

  void clear() {
    _vods = [];
    notifyListeners();
  }
}
