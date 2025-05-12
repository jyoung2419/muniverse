import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muniverse_app/models/event/detail/event_info_model.dart';
import '../../../services/event/event_title_service.dart';
import '../../../providers/language_provider.dart';

class EventInfoProvider with ChangeNotifier {
  final EventTitleService _eventInfoService;
  final LanguageProvider _languageProvider;

  String? _eventCode;
  EventInfoModel? _eventInfo;
  bool _isLoading = false;
  String? _error;

  EventInfoModel? get eventInfo => _eventInfo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EventInfoProvider(Dio dio, this._languageProvider)
      : _eventInfoService = EventTitleService(dio) {
    // ✅ 언어 변경 리스너 등록
    _languageProvider.addListener(() {
      if (_eventCode != null) {
        fetchEventInfo(_eventCode!); // 언어 바뀌면 자동으로 재요청
      }
    });
  }

  Future<void> fetchEventInfo(String eventCode) async {
    _eventCode = eventCode;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final content = await _eventInfoService.fetchEventInfoContent(eventCode);
      _eventInfo = EventInfoModel(content: content);
    } catch (e) {
      _error = '이벤트 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _eventInfo = null;
    _error = null;
    _isLoading = false;
    _eventCode = null;
    notifyListeners();
  }
}
