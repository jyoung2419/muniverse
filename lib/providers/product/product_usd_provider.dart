import 'package:flutter/material.dart';
import '../../models/product/product_event_usd_model.dart';  // ✅ 모델 경로 확인!
import '../../models/product/product_live_usd_model.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../services/user/product_service.dart';
import '../../utils/shared_prefs_util.dart';

class ProductUSDProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductVodUSDModel> _vods = [];
  List<ProductLiveUSDModel> _lives = [];
  bool _isLoading = false;
  String? _error;

  List<ProductVodUSDModel> get vods => _vods;
  List<ProductLiveUSDModel> get lives => _lives;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// USD 상품 데이터 조회
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final langHeader = await SharedPrefsUtil.getAcceptLanguage();
      final data = await _productService.fetchUSDProducts(langHeader: langHeader);
      final eventModel = ProductEventUSDModel.fromJson(data);
      _vods = eventModel.vods;
      _lives = eventModel.lives;
    } catch (e) {
      _error = '❌ 상품 정보를 불러오는 데 실패했습니다.';
      print('❌ ProductUSDProvider fetchProducts error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// 상태 초기화
  void clear() {
    _vods = [];
    _lives = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
