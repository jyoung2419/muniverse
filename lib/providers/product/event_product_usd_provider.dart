import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/product/product_group_usd_model.dart';
import '../../services/product/event_product_usd_service.dart';
import '../language_provider.dart';

class EventProductUSDProvider with ChangeNotifier {
  final EventProductUSDService _service;
  final LanguageProvider _languageProvider;

  ProductGroupUSDModel? _products;
  bool _isLoading = false;
  String? _error;

  ProductGroupUSDModel? get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? _latestEventCode;

  EventProductUSDProvider(Dio dio, this._languageProvider)
      : _service = EventProductUSDService(dio) {
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
