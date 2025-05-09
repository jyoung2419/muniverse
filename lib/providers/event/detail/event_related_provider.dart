import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/event_related_model.dart';
import '../../../services/event/event_title_service.dart';

class EventRelatedProvider with ChangeNotifier {
  final EventTitleService _eventTitleService;
  EventRelatedProvider(Dio dio) : _eventTitleService = EventTitleService(dio);

  List<EventRelatedModel> _relatedVideos = [];
  bool _isLoading = false;
  String? _error;

  List<EventRelatedModel> get relatedVideos => _relatedVideos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 특정 이벤트 코드 기반 관련영상 가져오기 (event detail 용)
  Future<void> fetchRelatedVideosByEventCode(String eventCode, {int? eventYear}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _eventTitleService.fetchEventRelatedVideos(eventCode, eventYear: eventYear);
      _relatedVideos = data.map((e) => EventRelatedModel.fromJson(e)).toList();
    } catch (e) {
      _error = '❌ 관련 영상을 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _relatedVideos = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
