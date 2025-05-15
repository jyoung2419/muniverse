import 'product_live_kr_model.dart';
import 'product_vod_kr_model.dart';

class ProductGroupKRModel {
  final List<ProductVodKRModel> vods;
  final List<ProductLiveKRModel> lives;

  ProductGroupKRModel({
    required this.vods,
    required this.lives,
  });

  factory ProductGroupKRModel.fromJson(Map<String, dynamic> json) {
    return ProductGroupKRModel(
      vods: (json['vods'] as List<dynamic>?)
          ?.map((e) => ProductVodKRModel.fromJson(e))
          .toList() ??
          [],
      lives: (json['lives'] as List<dynamic>?)
          ?.map((e) => ProductLiveKRModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
