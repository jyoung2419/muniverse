import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/product/product_group_kr_model.dart';
import '../../models/product/product_vod_kr_model.dart';
import '../../models/product/product_live_kr_model.dart';
import '../../services/product/product_service.dart';

class ProductKRProvider with ChangeNotifier {
  final ProductService _productService;
  ProductKRProvider(Dio dio) : _productService = ProductService(dio);

  List<ProductVodKRModel> _vods = [];
  List<ProductLiveKRModel> _lives = [];
  bool _isLoading = false;
  String? _error;

  List<ProductVodKRModel> get vods => _vods;
  List<ProductLiveKRModel> get lives => _lives;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// KR 상품 데이터 조회
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _productService.fetchKRProducts();
      final productGroup = ProductGroupKRModel.fromJson(data);
      _vods = productGroup.vods;
      _lives = productGroup.lives;
    } catch (e) {
      _error = '❌ 상품 정보를 불러오는 데 실패했습니다.';
      print('❌ ProductKRProvider fetchProducts error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _vods = [];
    _lives = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
