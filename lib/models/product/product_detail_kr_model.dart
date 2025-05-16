import 'product_view_type.dart';

class ProductDetailKRModel {
  final String productCode;
  final ProductViewType viewType;
  final String productImgUrl;
  final String name;
  final int priceWon;
  final int chargeWon;
  final int? discountRate;
  final int totalPrice;
  final String content;
  final String note;

  ProductDetailKRModel({
    required this.productCode,
    required this.viewType,
    required this.productImgUrl,
    required this.name,
    required this.priceWon,
    required this.chargeWon,
    this.discountRate,
    required this.totalPrice,
    required this.content,
    required this.note,
  });

  factory ProductDetailKRModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailKRModel(
      productCode: json['productCode'] ?? '',
      viewType: ProductViewType.values.byName(json['viewType'] ?? 'VOD'),
      productImgUrl: json['productImgUrl'] ?? '',
      name: json['name'] ?? '',
      priceWon: json['priceWon'] ?? 0,
      chargeWon: json['chargeWon'] ?? 0,
      discountRate: json['discountRate'],
      totalPrice: json['totalPrice'] ?? 0,
      content: json['content'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
