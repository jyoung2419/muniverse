import 'package:flutter/material.dart';
import 'product_card_base.dart';
import '../../models/product/product_vod_kr_model.dart';

class ProductCardKR extends StatelessWidget {
  final dynamic product;

  const ProductCardKR({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVod = product is ProductVodKRModel;

    return ProductCardBase(
      eventName: product.eventName ?? 'Unknown Event',
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '₩${product.totalPrice ?? 0}',
      isVod: isVod,
      buttonText: '구매하기',
      onPressed: () => print('구매: ${product.productCode}'),
    );
  }
}
