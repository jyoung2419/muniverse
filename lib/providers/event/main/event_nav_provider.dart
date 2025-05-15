import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../models/event/main/event_nav_model.dart';
import '../../../services/event/event_main_service.dart';

class EventNavProvider with ChangeNotifier {
  final EventMainService _eventMainService;

  EventNavProvider(Dio dio) : _eventMainService = EventMainService(dio);

  List<EventNavModel> _navs = [];
  List<EventNavModel> get navs => _navs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEventNavs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _navs = await _eventMainService.fetchEventNavList();
    } catch (e) {
      _navs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
