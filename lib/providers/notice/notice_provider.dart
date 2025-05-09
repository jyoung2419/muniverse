import 'package:flutter/material.dart';
import '../../models/notice/notice_model.dart';
import '../../services/notice/notice_service.dart';

class NoticeProvider with ChangeNotifier {
  List<NoticeModel> _notices = [];

  List<NoticeModel> get notices => _notices;

  final NoticeService _noticeService = NoticeService();

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
