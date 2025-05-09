import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/event_related_model.dart';
import '../../../services/event/event_main_service.dart';

class EventMainRelatedProvider with ChangeNotifier {
  final EventMainService _eventMainService;
  EventMainRelatedProvider(Dio dio) : _eventMainService = EventMainService(dio);

  List<EventRelatedModel> _relatedVideos = [];
  bool _isLoading = false;
  String? _error;

  List<EventRelatedModel> get relatedVideos => _relatedVideos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRelatedVideos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _eventMainService.fetchMainRelatedVideos();
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
