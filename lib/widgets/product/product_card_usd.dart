import 'package:flutter/material.dart';
import '../../models/product/product_live_usd_model.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../screens/product/product_detail_screen.dart';
import 'product_card_base.dart';

class ProductCardUSD extends StatelessWidget {
  final dynamic product;
  final List<String> viewTypes;

  const ProductCardUSD({
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
      priceLabel: '\$${product.totalPrice.toStringAsFixed(2)}',
      viewTypes: viewTypes,
      buttonText: 'BUY',
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
