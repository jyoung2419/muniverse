import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product/product_group_usd_model.dart';
import '../../models/product/product_live_usd_model.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../services/product/product_service.dart';
import '../../utils/shared_prefs_util.dart';
import '../../utils/dio_client.dart';

final productUSDProvider = StateNotifierProvider<ProductUSDNotifier, ProductUSDState>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductUSDNotifier(ProductService(dio));
});

class ProductUSDState {
  final List<ProductVodUSDModel> vods;
  final List<ProductLiveUSDModel> lives;
  final bool isLoading;
  final String? error;

  const ProductUSDState({
    this.vods = const [],
    this.lives = const [],
    this.isLoading = false,
    this.error,
  });

  ProductUSDState copyWith({
    List<ProductVodUSDModel>? vods,
    List<ProductLiveUSDModel>? lives,
    bool? isLoading,
    String? error,
  }) {
    return ProductUSDState(
      vods: vods ?? this.vods,
      lives: lives ?? this.lives,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductUSDNotifier extends StateNotifier<ProductUSDState> {
  final ProductService _productService;

  ProductUSDNotifier(this._productService) : super(const ProductUSDState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final langHeader = await SharedPrefsUtil.getAcceptLanguage();
      final data = await _productService.fetchUSDProducts(langHeader: langHeader);
      final productGroup = ProductGroupUSDModel.fromJson(data);
      state = state.copyWith(
        vods: productGroup.vods,
        lives: productGroup.lives,
        isLoading: false,
      );
    } catch (e) {
      print('❌ ProductUSDNotifier fetchProducts error: $e');
      state = state.copyWith(
        error: '❌ 상품 정보를 불러오는 데 실패했습니다.',
        isLoading: false,
      );
    }
  }

  void clear() {
    state = const ProductUSDState();
  }
}
