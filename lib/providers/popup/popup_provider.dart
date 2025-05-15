import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/popup/popup_model.dart';
import '../../services/popup/popup_service.dart';

class PopupProvider with ChangeNotifier {
  final PopupService _popupService;
  PopupListResponse? popupList;
  bool isLoaded = false;

  PopupProvider(Dio dio) : _popupService = PopupService(dio);

  Future<void> loadPopups() async {
    popupList = await _popupService.fetchPopupList();
    isLoaded = true;
    notifyListeners();
  }
}
