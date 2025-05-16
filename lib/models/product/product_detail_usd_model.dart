import 'product_view_type.dart';

class ProductDetailUSDModel {
  final String productCode;
  final ProductViewType viewType;
  final String productImgUrl;
  final String name;
  final double priceDollar;
  final double chargeDollar;
  final int? discountRate;
  final double totalPrice;
  final String content;
  final String note;

  ProductDetailUSDModel({
    required this.productCode,
    required this.viewType,
    required this.productImgUrl,
    required this.name,
    required this.priceDollar,
    required this.chargeDollar,
    this.discountRate,
    required this.totalPrice,
    required this.content,
    required this.note,
  });

  factory ProductDetailUSDModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailUSDModel(
      productCode: json['productCode'] ?? '',
      viewType: ProductViewType.values.byName(json['viewType'] ?? 'VOD'),
      productImgUrl: json['productImgUrl'] ?? '',
      name: json['name'] ?? '',
      priceDollar: (json['priceDollar'] ?? 0).toDouble(),
      chargeDollar: (json['chargeDollar'] ?? 0).toDouble(),
      discountRate: json['discountRate'],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      content: json['content'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
