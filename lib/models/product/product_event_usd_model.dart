// ProductUSDProvider 안에서 API 응답 파싱용.. 실제 UI 구현에는 사용x!!
import 'product_live_usd_model.dart';
import 'product_vod_usd_model.dart';

class ProductEventUSDModel {
  final List<ProductVodUSDModel> vods;
  final List<ProductLiveUSDModel> lives;

  ProductEventUSDModel({
    required this.vods,
    required this.lives,
  });

  factory ProductEventUSDModel.fromJson(Map<String, dynamic> json) {
    return ProductEventUSDModel(
      vods: (json['vods'] as List<dynamic>?)
          ?.map((e) => ProductVodUSDModel.fromJson(e))
          .toList() ??
          [],
      lives: (json['lives'] as List<dynamic>?)
          ?.map((e) => ProductLiveUSDModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
