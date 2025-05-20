import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/main/event_main_related_model.dart'; // 이걸로 바꿔야 함
import '../../../services/event/event_main_service.dart';

class EventMainRelatedProvider with ChangeNotifier {
  final EventMainService _eventMainService;
  EventMainRelatedProvider(Dio dio) : _eventMainService = EventMainService(dio);

  List<EventMainRelatedModel> _relatedGroups = [];
  bool _isLoading = false;
  String? _error;

  List<EventMainRelatedModel> get relatedGroups => _relatedGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRelatedGroups() async {
    if (_isLoading || _relatedGroups.isNotEmpty || _error != null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _eventMainService.fetchMainRelatedVideos(); // List<Map<String, dynamic>>
      _relatedGroups = data
          .map((e) => EventMainRelatedModel.fromJson(e))
          .toList();
    } catch (e) {
      _error = '❌ 관련 영상을 불러오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _relatedGroups = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
