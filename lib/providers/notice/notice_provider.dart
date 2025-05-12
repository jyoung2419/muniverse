import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/notice/notice_model.dart';
import '../../services/notice/notice_service.dart';
import '../language_provider.dart';

class NoticeProvider with ChangeNotifier {
  final NoticeService _noticeService;
  final LanguageProvider _languageProvider;

  List<NoticeModel> _notices = [];

  List<NoticeModel> get notices => _notices;

  NoticeProvider(Dio dio, this._languageProvider)
      : _noticeService = NoticeService(dio) {
    _languageProvider.addListener(() {
      fetchNotices();
    });
  }

  Future<void> fetchNotices() async {
    try {
      final List<Map<String, dynamic>> rawNotices = await _noticeService.fetchNotices();
      _notices = rawNotices.map((e) => NoticeModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to fetch notices: $e');
    }
  }
}
