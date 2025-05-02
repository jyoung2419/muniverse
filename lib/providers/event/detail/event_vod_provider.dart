import 'package:flutter/material.dart';
import '../../../models/event/detail/event_vod_model.dart';
import '../../../services/event/event_title_service.dart';

class EventVODProvider with ChangeNotifier {
  final EventTitleService _eventTitleService = EventTitleService();

  List<EventVODModel> _vods = [];

  List<EventVODModel> get vods => _vods;

  Future<void> fetchVODs(String eventCode, int eventYear) async {
    try {
      final List<Map<String, dynamic>> responseList =
      await _eventTitleService.fetchEventVODList(eventCode, eventYear);
      _vods = responseList.map((json) => EventVODModel.fromJson(json)).toList();
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
