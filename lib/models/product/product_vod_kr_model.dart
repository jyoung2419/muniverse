class ProductVodKRModel {
  final String productCode;
  final String name;
  final String note;
  final int priceWon;
  final int chargeWon;
  final int? discountRate;
  final int? totalPrice;
  final String productImageUrl;
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
    this.totalPrice,
    required this.productImageUrl,
    required this.isPackage,
    required this.categories,
  });

  factory ProductVodKRModel.fromJson(Map<String, dynamic> json) {
    return ProductVodKRModel(
      productCode: json['productCode'] ?? '',
      eventName: json['eventName'] ?? '',
      name: json['name'] ?? '',
      note: json['note'] ?? '',
      priceWon: json['priceWon'] ?? 0,
      chargeWon: json['chargeWon'] ?? 0,
      discountRate: json['discountRate'],
      totalPrice: json['totalPrice'],
      productImageUrl: json['productImageUrl'] ?? '',
      isPackage: json['package'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
