import 'product_item.dart';

class ProductVodKRModel implements ProductItem {
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

  final int priceWon;
  final int chargeWon;
  final int? discountRate;
  final bool isPackage;
  final List<String> categories;
  final String eventName;

  ProductVodKRModel({
    required this.productCode,
    required this.eventName,
    required this.name,
    required this.note,
    required this.priceWon,
    required this.chargeWon,
    this.discountRate,
    required int totalPrice,
    required this.productImageUrl,
    required this.isPackage,
    required this.categories,
  }) : totalPrice = totalPrice.toDouble();

  factory ProductVodKRModel.fromJson(Map<String, dynamic> json) {
    return ProductVodKRModel(
      productCode: json['productCode'] ?? '',
      eventName: json['eventName'] ?? '',
      name: json['name'] ?? '',
      note: json['note'] ?? '',
      priceWon: json['priceWon'] ?? 0,
      chargeWon: json['chargeWon'] ?? 0,
      discountRate: json['discountRate'],
      totalPrice: json['totalPrice'] ?? 0,
      productImageUrl: json['productImageUrl'] ?? '',
      isPackage: json['package'] ?? false,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}
