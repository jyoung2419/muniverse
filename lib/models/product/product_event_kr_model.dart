import 'product_live_kr_model.dart';
import 'product_vod_kr_model.dart';

class ProductEventKRModel {
  final List<ProductVodKRModel> vods;
  final List<ProductLiveKRModel> lives;

  ProductEventKRModel({
    required this.vods,
    required this.lives,
  });

  factory ProductEventKRModel.fromJson(Map<String, dynamic> json) {
    return ProductEventKRModel(
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
