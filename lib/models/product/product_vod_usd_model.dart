import 'product_usd_item.dart';

class ProductVodUSDModel implements ProductUSDItem {
  @override
  final String productCode;
  @override
  final String name;
  @override
  final String note;
  @override
  final String productImageUrl;
  @override
  final double totalPrice;

  @override
  bool get isVod => true;

  // 기존 필드 유지
  final double priceDollar;
  final double chargeDollar;
  final int? discountRate;
  final bool isPackage;
  final List<String> categories;

  ProductVodUSDModel({
    required this.productCode,
    required this.name,
    required this.note,
    required this.priceDollar,
    required this.chargeDollar,
    this.discountRate,
    required this.totalPrice,
    required this.productImageUrl,
    required this.isPackage,
    required this.categories,
  });

  factory ProductVodUSDModel.fromJson(Map<String, dynamic> json) {
    return ProductVodUSDModel(
      productCode: json['productCode'] ?? '',
      name: json['name'] ?? '',
      note: json['note'] ?? '',
      priceDollar: (json['priceDollar'] ?? 0).toDouble(),
      chargeDollar: (json['chargeDollar'] ?? 0).toDouble(),
      discountRate: json['discountRate'],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      productImageUrl: json['productImageUrl'] ?? '',
      isPackage: json['isPackage'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
