import 'package:flutter/material.dart';
import '../../../models/event/main/event_main_related_model.dart';
import '../../../services/event/event_main_service.dart';

class EventMainRelatedProvider with ChangeNotifier {
  final EventMainService _eventMainService = EventMainService();

  List<EventMainRelatedModel> _relatedVideos = [];
  bool _isLoading = false;
  String? _error;

  List<EventMainRelatedModel> get relatedVideos => _relatedVideos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRelatedVideos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _eventMainService.fetchMainRelatedVideos();
      _relatedVideos = data.map((e) => EventMainRelatedModel.fromJson(e)).toList();
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
