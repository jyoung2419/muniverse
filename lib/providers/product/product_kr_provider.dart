import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product/product_group_kr_model.dart';
import '../../models/product/product_live_kr_model.dart';
import '../../models/product/product_vod_kr_model.dart';
import '../../services/product/product_service.dart';
import '../../utils/dio_client.dart';

final productKRProvider = StateNotifierProvider<ProductKRNotifier, ProductKRState>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductKRNotifier(ProductService(dio));
});

class ProductKRState {
  final List<ProductVodKRModel> vods;
  final List<ProductLiveKRModel> lives;
  final bool isLoading;
  final String? error;

  const ProductKRState({
    this.vods = const [],
    this.lives = const [],
    this.isLoading = false,
    this.error,
  });

  ProductKRState copyWith({
    List<ProductVodKRModel>? vods,
    List<ProductLiveKRModel>? lives,
    bool? isLoading,
    String? error,
  }) {
    return ProductKRState(
      vods: vods ?? this.vods,
      lives: lives ?? this.lives,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductKRNotifier extends StateNotifier<ProductKRState> {
  final ProductService _productService;

  ProductKRNotifier(this._productService) : super(const ProductKRState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _productService.fetchKRProducts();
      final productGroup = ProductGroupKRModel.fromJson(data);
      state = state.copyWith(
        vods: productGroup.vods,
        lives: productGroup.lives,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '❌ 상품 정보를 불러오는 데 실패했습니다.',
      );
      print('❌ ProductKRNotifier fetchProducts error: $e');
    }
  }

  void clear() {
    state = const ProductKRState();
  }
}
