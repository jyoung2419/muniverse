import 'package:flutter/material.dart';
import '../../screens/product/product_detail_screen.dart';
import 'product_card_base.dart';

class ProductCardKR extends StatelessWidget {
  final dynamic product;
  final List<String> viewTypes;

  const ProductCardKR({
    super.key,
    required this.product,
    required this.viewTypes,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCardBase(
      eventName: product.eventName,
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '₩${product.totalPrice.toStringAsFixed(0)}',
      viewTypes: viewTypes,
      buttonText: '구매하기',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productCode: product.productCode,
              viewType: viewTypes.contains('PACKAGE') ? 'PACKAGE' : viewTypes.first,
              viewTypes: viewTypes,
              eventName: product.eventName,
            ),
          ),
        );
      },
    );
  }
}
