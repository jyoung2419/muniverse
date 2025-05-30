class OrderItem {
  final String viewType;
  final String productCode;
  final int amount;

  OrderItem({
    required this.viewType,
    required this.productCode,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'viewType': viewType,
      'productCode': productCode,
      'amount': amount,
    };
  }
}