import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/product/product_group_kr_model.dart';
import '../../services/product/event_product_kr_service.dart';
import '../language_provider.dart';

class EventProductKRProvider with ChangeNotifier {
  final EventProductKRService _service;
  final LanguageProvider _languageProvider;

  ProductGroupKRModel? _products;
  bool _isLoading = false;
  String? _error;

  ProductGroupKRModel? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? _latestEventCode;

  EventProductKRProvider(Dio dio, this._languageProvider)
      : _service = EventProductKRService(dio) {
    _languageProvider.addListener(() {
      if (_latestEventCode != null) {
        loadProducts(_latestEventCode!);
      }
    });
  }

  Future<void> loadProducts(String eventCode) async {
    _isLoading = true;
    _error = null;
    _latestEventCode = eventCode;
    notifyListeners();

    try {
      _products = await _service.fetchEventProducts(eventCode);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
