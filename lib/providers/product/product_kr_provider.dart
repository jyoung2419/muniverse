import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/product/product_event_kr_model.dart';
import '../../services/product/product_service.dart';

class ProductKRProvider with ChangeNotifier {
  final ProductService _productService;
  ProductKRProvider(Dio dio) : _productService = ProductService(dio);

  ProductEventKRModel? _productData;
  bool _isLoading = false;
  String? _error;

  ProductEventKRModel? get productData => _productData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchKRProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _productService.fetchKRProducts();
      _productData = ProductEventKRModel.fromJson(data);
    } catch (e) {
      _error = '❌ 상품 데이터를 불러오는데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
