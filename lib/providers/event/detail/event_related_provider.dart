import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/detail/event_related_model.dart';
import '../../../services/event/event_title_service.dart';

class EventRelatedProvider with ChangeNotifier {
  final EventTitleService _eventTitleService;
  EventRelatedProvider(Dio dio) : _eventTitleService = EventTitleService(dio);

  List<EventRelatedModel> _relatedVideos = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  bool _isLastPage = false;

  List<EventRelatedModel> get relatedVideos => _relatedVideos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLastPage => _isLastPage;

  /// 특정 이벤트 코드 기반 관련영상 가져오기 (event detail 용)
  Future<void> fetchNextPage(String eventCode, {int? eventYear}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _eventTitleService.fetchEventRelatedVideos(
        eventCode,
        eventYear: eventYear,
        page: _currentPage,
        size: 10,
      );
      final videos = data.map((e) => EventRelatedModel.fromJson(e)).toList();

      if (videos.isEmpty) _isLastPage = true;
      _relatedVideos.addAll(videos);
      _currentPage += 1;
    } catch (e) {
      _error = '❌ 관련 영상 추가 로드 실패';
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
