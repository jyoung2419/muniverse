import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/product/product_detail_kr_model.dart';
import '../../models/product/product_detail_usd_model.dart';
import '../../providers/language_provider.dart';
import '../../services/product/product_detail_service.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductDetailService _service;
  final LanguageProvider _languageProvider;

  ProductDetailKRModel? _krDetail;
  ProductDetailUSDModel? _usdDetail;
  String? _productCode;
  String? _viewType;

  ProductDetailKRModel? get krDetail => _krDetail;
  ProductDetailUSDModel? get usdDetail => _usdDetail;

  ProductDetailProvider(Dio dio, this._languageProvider)
      : _service = ProductDetailService(dio) {
    _languageProvider.addListener(() {
      if (_productCode != null && _viewType != null) {
        fetchDetail(_productCode!, _viewType!);
      }
    });
  }

  Future<void> fetchDetail(String productCode, String viewType) async {
    _productCode = productCode;
    _viewType = viewType;

    final langCode = _languageProvider.selectedLanguageCode;

    if (langCode == 'kr') {
      final json = await _service.fetchKRProductDetail(
        productCode: productCode,
        viewType: viewType,
      );
      _krDetail = ProductDetailKRModel.fromJson(json);
      _usdDetail = null;
    } else {
      final json = await _service.fetchUSDProductDetail(
        productCode: productCode,
        viewType: viewType,
      );
      _usdDetail = ProductDetailUSDModel.fromJson(json);
      _krDetail = null;
    }

    notifyListeners();
  }

  void clear() {
    _productCode = null;
    _viewType = null;
    _krDetail = null;
    _usdDetail = null;
    notifyListeners();
  }
}
