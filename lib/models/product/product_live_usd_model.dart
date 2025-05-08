class ProductLiveUSDModel {
  final String productCode;
  final String name;
  final String note;
  final double priceDollar;
  final double chargeDollar;
  final int? discountRate;
  final double totalPrice;
  final String productImageUrl;
  final bool isPackage;
  final List<String> categories;

  ProductLiveUSDModel({
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

  factory ProductLiveUSDModel.fromJson(Map<String, dynamic> json) {
    return ProductLiveUSDModel(
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
