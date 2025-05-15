import 'product_live_usd_model.dart';
import 'product_vod_usd_model.dart';

class ProductGroupUSDModel {
  final List<ProductVodUSDModel> vods;
  final List<ProductLiveUSDModel> lives;

  ProductGroupUSDModel({
    required this.vods,
    required this.lives,
  });

  factory ProductGroupUSDModel.fromJson(Map<String, dynamic> json) {
    return ProductGroupUSDModel(
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
