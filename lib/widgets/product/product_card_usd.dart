import 'package:flutter/material.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../screens/product/product_detail_screen.dart';
import 'product_card_base.dart';

class ProductCardUSD extends StatelessWidget {
  final dynamic product;

  const ProductCardUSD({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVod = product is ProductVodUSDModel;
    final viewType = isVod ? 'VOD' : 'LIVE';

    return ProductCardBase(
      eventName: product.eventName,
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '\$${product.totalPrice.toStringAsFixed(2)}',
      isVod: isVod,
      buttonText: 'BUY',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productCode: product.productCode,
              viewType: viewType,
              eventName: product.eventName,
            ),
          ),
        );
      },
    );
  }
}
